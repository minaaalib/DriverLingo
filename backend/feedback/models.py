from django.conf import settings
from django.db import models


class Feedback(models.Model):
    class Category(models.TextChoices):
        BUG = "bug", "Bug report"
        CONTENT = "content", "Question / content issue"
        SUGGESTION = "suggestion", "Suggestion"
        OTHER = "other", "Other"

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, on_delete=models.SET_NULL, null=True, blank=True, related_name="feedback_entries"
    )
    category = models.CharField(max_length=20, choices=Category.choices, default=Category.OTHER)
    message = models.TextField()
    related_question = models.ForeignKey(
        "questions.Question", on_delete=models.SET_NULL, null=True, blank=True, related_name="feedback_entries"
    )
    is_resolved = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = "feedback"
        ordering = ["-created_at"]

    def __str__(self):
        who = self.user.email if self.user else "anonymous"
        return f"[{self.category}] {who}: {self.message[:50]}"
