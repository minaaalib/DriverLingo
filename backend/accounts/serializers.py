from django.contrib.auth import password_validation
from django.core.exceptions import ValidationError as DjangoValidationError
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import User


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    password_confirmation = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "name", "email", "password", "password_confirmation"]
        read_only_fields = ["id"]

    def validate_email(self, value):
        value = value.lower().strip()
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError("An account with this email already exists.")
        return value

    def validate(self, attrs):
        if attrs["password"] != attrs.pop("password_confirmation"):
            raise serializers.ValidationError({"password_confirmation": "Passwords do not match."})
        try:
            password_validation.validate_password(attrs["password"])
        except DjangoValidationError as exc:
            raise serializers.ValidationError({"password": list(exc.messages)})
        return attrs

    def create(self, validated_data):
        return User.objects.create_user(
            email=validated_data["email"],
            name=validated_data["name"],
            password=validated_data["password"],
            role=User.Role.USER,
        )


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            "id",
            "name",
            "email",
            "role",
            "email_verified_at",
            "is_active",
            "created_at",
            "updated_at",
        ]
        read_only_fields = fields


class AdminUserSerializer(serializers.ModelSerializer):
    """Used by the admin-only user management endpoints."""

    exam_count = serializers.IntegerField(source="exams.count", read_only=True)

    class Meta:
        model = User
        fields = [
            "id",
            "name",
            "email",
            "role",
            "email_verified_at",
            "is_active",
            "created_at",
            "updated_at",
            "exam_count",
        ]
        read_only_fields = ["id", "created_at", "updated_at", "exam_count"]


class LoginSerializer(TokenObtainPairSerializer):
    """Extends SimpleJWT's serializer to authenticate by email and embed
    the user's role/profile in the token response payload."""

    username_field = User.USERNAME_FIELD

    def validate(self, attrs):
        data = super().validate(attrs)
        data["user"] = UserSerializer(self.user).data
        return data

    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token["role"] = user.role
        token["name"] = user.name
        return token


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(write_only=True)
    new_password = serializers.CharField(write_only=True, min_length=8)

    def validate_new_password(self, value):
        password_validation.validate_password(value)
        return value


class PasswordResetRequestSerializer(serializers.Serializer):
    email = serializers.EmailField()


class PasswordResetConfirmSerializer(serializers.Serializer):
    token = serializers.UUIDField()
    new_password = serializers.CharField(write_only=True, min_length=8)

    def validate_new_password(self, value):
        password_validation.validate_password(value)
        return value


class ResendVerificationSerializer(serializers.Serializer):
    email = serializers.EmailField()


class GoogleAuthSerializer(serializers.Serializer):
    id_token = serializers.CharField()
