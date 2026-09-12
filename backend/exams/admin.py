from django.contrib import admin

from .models import Exam, ExamResponse


class ExamResponseInline(admin.TabularInline):
    model = ExamResponse
    extra = 0
    readonly_fields = ["question", "order", "selected_answer", "is_correct", "answered_at"]
    can_delete = False

    def has_add_permission(self, request, obj=None):
        return False


@admin.register(Exam)
class ExamAdmin(admin.ModelAdmin):
    list_display = ["id", "user", "category", "language_used", "status", "score", "total_questions", "started_at"]
    list_filter = ["category", "language_used", "status"]
    search_fields = ["user__email", "user__name"]
    readonly_fields = ["started_at", "submitted_at", "score"]
    inlines = [ExamResponseInline]

    def has_add_permission(self, request):
        # Exams are only ever created through the mock-exam API flow.
        return False
