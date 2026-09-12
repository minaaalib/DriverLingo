from django.contrib import admin

from .models import Feedback


@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display = ["id", "category", "user", "short_message", "is_resolved", "created_at"]
    list_filter = ["category", "is_resolved"]
    search_fields = ["message", "user__email"]
    list_editable = ["is_resolved"]

    @admin.display(description="Message")
    def short_message(self, obj):
        return obj.message[:80]
