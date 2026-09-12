from django.conf import settings
from django.shortcuts import get_object_or_404
from django.utils import timezone
from google.auth.transport import requests as google_requests
from google.oauth2 import id_token as google_id_token
from rest_framework import generics, mixins, permissions, status, viewsets
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.exceptions import TokenError
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView

from .emails import send_password_reset_email, send_verification_email
from .models import EmailVerificationToken, PasswordResetToken, User
from .permissions import IsAdminRole
from .serializers import (
    AdminUserSerializer,
    ChangePasswordSerializer,
    GoogleAuthSerializer,
    LoginSerializer,
    PasswordResetConfirmSerializer,
    PasswordResetRequestSerializer,
    RegisterSerializer,
    ResendVerificationSerializer,
    UserSerializer,
)


class RegisterView(generics.CreateAPIView):
    """POST /api/auth/register - Register a new examinee account.

    Sends an email verification link/token on success. The account can
    log in immediately, but some clients may choose to require
    ``email_verified_at`` before letting the user take a graded exam.
    """

    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        verification = EmailVerificationToken.objects.create(user=user)
        send_verification_email(user, verification.token)

        return Response(
            {
                "message": "Registration successful. Please check your email to verify your account.",
                "user": UserSerializer(user).data,
            },
            status=status.HTTP_201_CREATED,
        )


class LoginView(TokenObtainPairView):
    """POST /api/auth/login - Authenticate with email + password, returns
    JWT access/refresh tokens plus the user's profile."""

    serializer_class = LoginSerializer
    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"


class GoogleAuthView(APIView):
    """POST /api/auth/google - Authenticate with a Google ID token.

    Verifies the token against Google, then gets-or-creates the matching
    user by email (Google has already verified that address, so the
    account is marked verified immediately). Returns the same
    access/refresh/user payload shape as ``LoginView``.
    """

    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def post(self, request):
        serializer = GoogleAuthSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        try:
            payload = google_id_token.verify_oauth2_token(
                serializer.validated_data["id_token"],
                google_requests.Request(),
                settings.GOOGLE_OAUTH_CLIENT_ID,
            )
        except ValueError:
            return Response({"detail": "Invalid Google token."}, status=status.HTTP_400_BAD_REQUEST)

        email = payload.get("email")
        if not email or not payload.get("email_verified"):
            return Response({"detail": "Google account has no verified email."}, status=status.HTTP_400_BAD_REQUEST)

        user, created = User.objects.get_or_create(
            email__iexact=email,
            defaults={
                "email": email.lower(),
                "name": payload.get("name") or email.split("@")[0],
                "role": User.Role.USER,
                "email_verified_at": timezone.now(),
            },
        )
        if created:
            user.set_unusable_password()
            user.save(update_fields=["password"])
        elif not user.is_email_verified:
            user.email_verified_at = timezone.now()
            user.save(update_fields=["email_verified_at", "updated_at"])

        token = LoginSerializer.get_token(user)
        return Response(
            {
                "access": str(token.access_token),
                "refresh": str(token),
                "user": UserSerializer(user).data,
            }
        )


class LogoutView(APIView):
    """POST /api/auth/logout - Blacklists the supplied refresh token so it
    can no longer be used to obtain new access tokens."""

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        refresh_token = request.data.get("refresh")
        if not refresh_token:
            return Response({"detail": "'refresh' token is required."}, status=status.HTTP_400_BAD_REQUEST)
        try:
            token = RefreshToken(refresh_token)
            token.blacklist()
        except TokenError:
            return Response({"detail": "Invalid or already-blacklisted token."}, status=status.HTTP_400_BAD_REQUEST)
        return Response({"message": "Logged out successfully."}, status=status.HTTP_205_RESET_CONTENT)


class VerifyEmailView(APIView):
    """GET /api/auth/verify-email/{token} - Verifies a user's email."""

    permission_classes = [permissions.AllowAny]

    def get(self, request, token):
        verification = get_object_or_404(EmailVerificationToken, token=token)
        if not verification.is_valid:
            return Response({"detail": "This verification link is invalid or has expired."}, status=status.HTTP_400_BAD_REQUEST)

        user = verification.user
        user.email_verified_at = timezone.now()
        user.save(update_fields=["email_verified_at", "updated_at"])
        verification.used_at = timezone.now()
        verification.save(update_fields=["used_at"])

        return Response({"message": "Email verified successfully. You may now log in."})


class ResendVerificationEmailView(APIView):
    """POST /api/auth/resend-verification - Issues a fresh verification token."""

    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def post(self, request):
        serializer = ResendVerificationSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            user = User.objects.get(email__iexact=serializer.validated_data["email"])
        except User.DoesNotExist:
            # Do not reveal whether the email is registered.
            return Response({"message": "If that account exists, a verification email has been sent."})

        if user.is_email_verified:
            return Response({"message": "This account is already verified."})

        verification = EmailVerificationToken.objects.create(user=user)
        send_verification_email(user, verification.token)
        return Response({"message": "If that account exists, a verification email has been sent."})


class PasswordResetRequestView(APIView):
    """POST /api/auth/password-reset/request - Emails a reset token/link."""

    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def post(self, request):
        serializer = PasswordResetRequestSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            user = User.objects.get(email__iexact=serializer.validated_data["email"])
        except User.DoesNotExist:
            return Response({"message": "If that account exists, a password reset email has been sent."})

        reset_token = PasswordResetToken.objects.create(user=user)
        send_password_reset_email(user, reset_token.token)
        return Response({"message": "If that account exists, a password reset email has been sent."})


class PasswordResetConfirmView(APIView):
    """POST /api/auth/password-reset/confirm - Sets a new password given a
    valid reset token."""

    permission_classes = [permissions.AllowAny]
    throttle_scope = "auth"

    def post(self, request):
        serializer = PasswordResetConfirmSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        token = get_object_or_404(PasswordResetToken, token=serializer.validated_data["token"])
        if not token.is_valid:
            return Response({"detail": "This reset link is invalid or has expired."}, status=status.HTTP_400_BAD_REQUEST)

        user = token.user
        user.set_password(serializer.validated_data["new_password"])
        user.save(update_fields=["password", "updated_at"])
        token.used_at = timezone.now()
        token.save(update_fields=["used_at"])

        return Response({"message": "Password reset successfully. You may now log in."})


class ChangePasswordView(APIView):
    """POST /api/auth/change-password - For an already-authenticated user."""

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        serializer = ChangePasswordSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = request.user
        if not user.check_password(serializer.validated_data["old_password"]):
            return Response({"old_password": "Incorrect password."}, status=status.HTTP_400_BAD_REQUEST)
        user.set_password(serializer.validated_data["new_password"])
        user.save(update_fields=["password", "updated_at"])
        return Response({"message": "Password changed successfully."})


class MeView(APIView):
    """GET/PATCH /api/auth/me - the current user's own profile."""

    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        return Response(UserSerializer(request.user).data)

    def patch(self, request):
        allowed = {"name"}
        for field in list(request.data.keys()):
            if field not in allowed:
                request.data.pop(field)
        user = request.user
        if "name" in request.data:
            user.name = request.data["name"]
            user.save(update_fields=["name", "updated_at"])
        return Response(UserSerializer(user).data)


class UserManagementViewSet(
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet,
):
    """
    Admin-only user management.

    GET /api/users            - list all users
    GET /api/users/{id}       - user details
    DELETE /api/users/{id}    - delete a user
    """

    queryset = User.objects.all().order_by("-created_at")
    serializer_class = AdminUserSerializer
    permission_classes = [IsAdminRole]
    filterset_fields = ["role", "is_active"]
    search_fields = ["name", "email"]
    ordering_fields = ["created_at", "name", "email"]

    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if instance == request.user:
            return Response(
                {"detail": "You cannot delete your own account through this endpoint."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        instance.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
