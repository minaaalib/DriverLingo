from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as DjangoUserAdmin

from .models import EmailVerificationToken, PasswordResetToken, User


@admin.register(User)
class UserAdmin(DjangoUserAdmin):
    ordering = ["-created_at"]
    list_display = ["email", "name", "role", "is_active", "email_verified_badge", "created_at"]
    list_filter = ["role", "is_active", "is_staff"]
    search_fields = ["name", "email"]
    readonly_fields = ["created_at", "updated_at", "last_login"]

    fieldsets = (
        (None, {"fields": ("email", "password")}),
        ("Profile", {"fields": ("name", "role")}),
        (
            "Permissions",
            {"fields": ("is_active", "is_staff", "is_superuser", "groups", "user_permissions")},
        ),
        ("Verification", {"fields": ("email_verified_at",)}),
        ("Important dates", {"fields": ("last_login", "created_at", "updated_at")}),
    )
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": ("email", "name", "role", "password1", "password2"),
            },
        ),
    )

    @admin.display(boolean=True, description="Verified")
    def email_verified_badge(self, obj):
        return obj.is_email_verified


@admin.register(EmailVerificationToken)
class EmailVerificationTokenAdmin(admin.ModelAdmin):
    list_display = ["user", "token", "created_at", "used_at"]
    readonly_fields = ["token", "created_at"]
    search_fields = ["user__email"]


@admin.register(PasswordResetToken)
class PasswordResetTokenAdmin(admin.ModelAdmin):
    list_display = ["user", "token", "created_at", "used_at"]
    readonly_fields = ["token", "created_at"]
    search_fields = ["user__email"]
