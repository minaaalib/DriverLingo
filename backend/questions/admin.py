from django.contrib import admin
from django.utils.html import format_html

from .models import Question


def _thumb(image_field, size=60):
    if not image_field:
        return "—"
    return format_html(
        '<img src="{}" style="height:{}px;border-radius:4px;object-fit:cover;" />',
        image_field.url,
        size,
    )


@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = [
        "id",
        "short_question",
        "category",
        "correct_answer",
        "question_thumb",
        "is_active",
        "needs_review",
        "updated_at",
    ]
    list_filter = ["category", "is_active", "needs_review", "correct_answer"]
    search_fields = ["question_en", "question_ph", "question_hl"]
    list_editable = ["is_active", "needs_review"]
    readonly_fields = ["created_at", "updated_at", "created_by", "question_preview", "option_a_preview", "option_b_preview", "option_c_preview"]
    fieldsets = (
        (
            "Question",
            {
                "fields": (
                    ("question_en",),
                    ("question_ph",),
                    ("question_hl",),
                    ("question_photo", "question_preview"),
                )
            },
        ),
        (
            "Option A",
            {"fields": (("option_a_en",), ("option_a_ph",), ("option_a_hl",), ("option_a_photo", "option_a_preview"))},
        ),
        (
            "Option B",
            {"fields": (("option_b_en",), ("option_b_ph",), ("option_b_hl",), ("option_b_photo", "option_b_preview"))},
        ),
        (
            "Option C",
            {"fields": (("option_c_en",), ("option_c_ph",), ("option_c_hl",), ("option_c_photo", "option_c_preview"))},
        ),
        (
            "Grading & explanation",
            {"fields": ("correct_answer", "explanation_en", "explanation_ph", "explanation_hl", "needs_review")},
        ),
        ("Exam configuration", {"fields": ("category", "is_active")}),
        ("Metadata", {"fields": ("created_by", "created_at", "updated_at")}),
    )
    actions = ["mark_reviewed", "mark_needs_review", "deactivate", "activate"]

    @admin.display(description="Question")
    def short_question(self, obj):
        return (obj.question_en or "")[:70]

    @admin.display(description="Photo")
    def question_thumb(self, obj):
        return _thumb(obj.question_photo, size=40)

    @admin.display(description="Preview")
    def question_preview(self, obj):
        return _thumb(obj.question_photo, size=160)

    @admin.display(description="Preview")
    def option_a_preview(self, obj):
        return _thumb(obj.option_a_photo, size=120)

    @admin.display(description="Preview")
    def option_b_preview(self, obj):
        return _thumb(obj.option_b_photo, size=120)

    @admin.display(description="Preview")
    def option_c_preview(self, obj):
        return _thumb(obj.option_c_photo, size=120)

    @admin.action(description="Mark selected questions as reviewed")
    def mark_reviewed(self, request, queryset):
        queryset.update(needs_review=False)

    @admin.action(description="Flag selected questions for review")
    def mark_needs_review(self, request, queryset):
        queryset.update(needs_review=True)

    @admin.action(description="Deactivate selected questions (hide from exams)")
    def deactivate(self, request, queryset):
        queryset.update(is_active=False)

    @admin.action(description="Activate selected questions")
    def activate(self, request, queryset):
        queryset.update(is_active=True)

    def save_model(self, request, obj, form, change):
        if not change and not obj.created_by:
            obj.created_by = request.user
        super().save_model(request, obj, form, change)
