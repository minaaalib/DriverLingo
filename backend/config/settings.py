"""
Django settings for the LTO Exam Reviewer Mobile App backend.

This backend powers a driver's license exam reviewer for the Philippine
Land Transportation Office (LTO), with content in English, Filipino, and
Hiligaynon for Ilonggo drivers.
"""

from datetime import timedelta
from pathlib import Path

from decouple import Csv, config

BASE_DIR = Path(__file__).resolve().parent.parent

# ---------------------------------------------------------------------------
# Core / security
# ---------------------------------------------------------------------------

SECRET_KEY = config(
    "SECRET_KEY",
    default="django-insecure-change-me-in-production-*3-zbofwih+51v0r6aw)4l27^*5t^h8",
)

DEBUG = config("DEBUG", default=True, cast=bool)

ALLOWED_HOSTS = config("ALLOWED_HOSTS", default="localhost,127.0.0.1", cast=Csv())

# Railway (and most PaaS hosts) terminate HTTPS at a proxy and forward plain
# HTTP internally, tagging the original scheme in this header. Without it,
# request.is_secure() is always False, which breaks CSRF's Origin check for
# the Django admin.
SECURE_PROXY_SSL_HEADER = ("HTTP_X_FORWARDED_PROTO", "https")

# ---------------------------------------------------------------------------
# Applications
# ---------------------------------------------------------------------------

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # Third-party
    "rest_framework",
    "rest_framework_simplejwt",
    "rest_framework_simplejwt.token_blacklist",
    "corsheaders",
    "django_filters",
    "drf_spectacular",
    # Local apps
    "accounts",
    "questions",
    "exams",
    "feedback",
    "reviewer",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "whitenoise.middleware.WhiteNoiseMiddleware",
    "corsheaders.middleware.CorsMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "config.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [BASE_DIR / "templates"],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

WSGI_APPLICATION = "config.wsgi.application"

# ---------------------------------------------------------------------------
# Database
#
# Defaults to SQLite for local development. Set USE_POSTGRES=True (and the
# related DB_* env vars) to run against PostgreSQL in production.
# ---------------------------------------------------------------------------

if config("USE_POSTGRES", default=False, cast=bool):
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.postgresql",
            "NAME": config("DB_NAME", default="lto_reviewer"),
            "USER": config("DB_USER", default="postgres"),
            "PASSWORD": config("DB_PASSWORD", default=""),
            "HOST": config("DB_HOST", default="localhost"),
            "PORT": config("DB_PORT", default="5432"),
            "OPTIONS": {"sslmode": config("DB_SSLMODE", default="prefer")},
        }
    }
else:
    DATABASES = {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": BASE_DIR / "db.sqlite3",
        }
    }

# ---------------------------------------------------------------------------
# Auth
# ---------------------------------------------------------------------------

AUTH_USER_MODEL = "accounts.User"

AUTH_PASSWORD_VALIDATORS = [
    {"NAME": "django.contrib.auth.password_validation.UserAttributeSimilarityValidator"},
    {"NAME": "django.contrib.auth.password_validation.MinimumLengthValidator"},
    {"NAME": "django.contrib.auth.password_validation.CommonPasswordValidator"},
    {"NAME": "django.contrib.auth.password_validation.NumericPasswordValidator"},
]

# ---------------------------------------------------------------------------
# Internationalization
# ---------------------------------------------------------------------------

LANGUAGE_CODE = "en-us"
TIME_ZONE = config("TIME_ZONE", default="Asia/Manila")
USE_I18N = True
USE_TZ = True

# ---------------------------------------------------------------------------
# Static & media files
# ---------------------------------------------------------------------------

STATIC_URL = "static/"
STATIC_ROOT = BASE_DIR / "staticfiles"
STORAGES = {
    "default": {"BACKEND": "django.core.files.storage.FileSystemStorage"},
    "staticfiles": {"BACKEND": "whitenoise.storage.CompressedManifestStaticFilesStorage"},
}

MEDIA_URL = "/media/"
MEDIA_ROOT = BASE_DIR / "media"

DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# ---------------------------------------------------------------------------
# Django REST Framework
# ---------------------------------------------------------------------------

REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": (
        "rest_framework_simplejwt.authentication.JWTAuthentication",
    ),
    "DEFAULT_PERMISSION_CLASSES": ("rest_framework.permissions.IsAuthenticated",),
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
    "DEFAULT_FILTER_BACKENDS": (
        "django_filters.rest_framework.DjangoFilterBackend",
        "rest_framework.filters.SearchFilter",
        "rest_framework.filters.OrderingFilter",
    ),
    "DEFAULT_SCHEMA_CLASS": "drf_spectacular.openapi.AutoSchema",
    "DEFAULT_THROTTLE_CLASSES": (
        "rest_framework.throttling.ScopedRateThrottle",
    ),
    "DEFAULT_THROTTLE_RATES": {
        "auth": "20/min",
    },
}

SPECTACULAR_SETTINGS = {
    "TITLE": "LTO Exam Reviewer API",
    "DESCRIPTION": (
        "API for the LTO Exam Reviewer Mobile App with Hiligaynon Translation. "
        "Serves multilingual (English / Filipino / Hiligaynon) LTO driver's "
        "license exam questions, mock exams, and results."
    ),
    "VERSION": "1.0.0",
    "SERVE_INCLUDE_SCHEMA": False,
}

# ---------------------------------------------------------------------------
# Simple JWT
# ---------------------------------------------------------------------------

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(minutes=config("ACCESS_TOKEN_LIFETIME_MIN", default=60, cast=int)),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=config("REFRESH_TOKEN_LIFETIME_DAYS", default=14, cast=int)),
    "ROTATE_REFRESH_TOKENS": True,
    "BLACKLIST_AFTER_ROTATION": True,
    "UPDATE_LAST_LOGIN": True,
    "AUTH_HEADER_TYPES": ("Bearer",),
    "USER_ID_FIELD": "id",
    "USER_ID_CLAIM": "user_id",
}

# ---------------------------------------------------------------------------
# Google Sign-In
#
# The Web OAuth client ID from Google Cloud Console. Its audience must match
# the `aud` claim on the ID token the app sends to POST /api/auth/google.
# ---------------------------------------------------------------------------

GOOGLE_OAUTH_CLIENT_ID = config("GOOGLE_OAUTH_CLIENT_ID", default="")

# ---------------------------------------------------------------------------
# CORS
# ---------------------------------------------------------------------------

CORS_ALLOW_ALL_ORIGINS = config("CORS_ALLOW_ALL_ORIGINS", default=True, cast=bool)
CORS_ALLOWED_ORIGINS = config("CORS_ALLOWED_ORIGINS", default="", cast=Csv())

# ---------------------------------------------------------------------------
# Email (registration / verification / password reset / exam completion)
#
# Defaults to the console backend for local development so emails are
# visible in the runserver output. Set EMAIL_BACKEND in production.
# ---------------------------------------------------------------------------

EMAIL_BACKEND = config(
    "EMAIL_BACKEND", default="django.core.mail.backends.console.EmailBackend"
)
EMAIL_HOST = config("EMAIL_HOST", default="smtp.gmail.com")
EMAIL_PORT = config("EMAIL_PORT", default=587, cast=int)
EMAIL_USE_TLS = config("EMAIL_USE_TLS", default=True, cast=bool)
EMAIL_HOST_USER = config("EMAIL_HOST_USER", default="")
EMAIL_HOST_PASSWORD = config("EMAIL_HOST_PASSWORD", default="")
DEFAULT_FROM_EMAIL = config("DEFAULT_FROM_EMAIL", default="LTO Exam Reviewer <no-reply@ltoreviewer.local>")

# Public URL of the API / a companion web page, used to build links inside
# verification and password-reset emails. The mobile app can also handle
# these via deep links (see FRONTEND_DEEP_LINK_SCHEME).
FRONTEND_BASE_URL = config("FRONTEND_BASE_URL", default="http://localhost:8000")
EMAIL_VERIFICATION_TOKEN_EXPIRY_HOURS = config("EMAIL_VERIFICATION_TOKEN_EXPIRY_HOURS", default=48, cast=int)
PASSWORD_RESET_TOKEN_EXPIRY_HOURS = config("PASSWORD_RESET_TOKEN_EXPIRY_HOURS", default=2, cast=int)

# ---------------------------------------------------------------------------
# Mock exam defaults
# ---------------------------------------------------------------------------

# Standard number of items LTO uses per category; the mobile app offers
# these as presets but a user may otherwise pick any question count.
EXAM_STANDARD_QUESTION_COUNTS = {
    "student": 40,
    "non_professional": 40,
    "professional": 60,
}
