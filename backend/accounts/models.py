import uuid
from datetime import timedelta

from django.conf import settings
from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import PermissionsMixin
from django.db import models
from django.utils import timezone


class UserManager(BaseUserManager):
    """Custom manager since the app authenticates by email, not username."""

    use_in_migrations = True

    def _create_user(self, email, password, **extra_fields):
        if not email:
            raise ValueError("Users must have an email address.")
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        extra_fields.setdefault("role", User.Role.USER)
        extra_fields.setdefault("is_staff", False)
        extra_fields.setdefault("is_superuser", False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault("role", User.Role.ADMIN)
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)
        extra_fields.setdefault("email_verified_at", timezone.now())

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self._create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    """
    Examinee / Admin account.

    Field names mirror the original ``users`` table design (id, name,
    email, password, role, email_verified_at, remember_token, timestamps)
    while adopting Django conventions (is_active/is_staff for the admin
    site, PermissionsMixin for groups/permissions).
    """

    class Role(models.TextChoices):
        ADMIN = "admin", "Admin"
        USER = "user", "User"

    name = models.CharField(max_length=150)
    email = models.EmailField(unique=True)
    role = models.CharField(max_length=10, choices=Role.choices, default=Role.USER)

    email_verified_at = models.DateTimeField(null=True, blank=True)

    # Kept for schema parity with the original design; JWT refresh tokens
    # (see rest_framework_simplejwt) are what actually authorize sessions,
    # this field is not used for authentication.
    remember_token = models.CharField(max_length=255, null=True, blank=True)

    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = UserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["name"]

    class Meta:
        db_table = "users"
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.name} <{self.email}>"

    @property
    def is_admin(self):
        return self.role == self.Role.ADMIN

    @property
    def is_email_verified(self):
        return self.email_verified_at is not None


class EmailVerificationToken(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="email_verification_tokens"
    )
    token = models.UUIDField(default=uuid.uuid4, unique=True, editable=False)
    created_at = models.DateTimeField(auto_now_add=True)
    used_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "email_verification_tokens"

    @property
    def is_expired(self):
        expiry = self.created_at + timedelta(hours=settings.EMAIL_VERIFICATION_TOKEN_EXPIRY_HOURS)
        return timezone.now() > expiry

    @property
    def is_valid(self):
        return self.used_at is None and not self.is_expired


class PasswordResetToken(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="password_reset_tokens"
    )
    token = models.UUIDField(default=uuid.uuid4, unique=True, editable=False)
    created_at = models.DateTimeField(auto_now_add=True)
    used_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "password_reset_tokens"

    @property
    def is_expired(self):
        expiry = self.created_at + timedelta(hours=settings.PASSWORD_RESET_TOKEN_EXPIRY_HOURS)
        return timezone.now() > expiry

    @property
    def is_valid(self):
        return self.used_at is None and not self.is_expired
