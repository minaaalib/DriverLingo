import random

from django.conf import settings
from django.db import models
from django.utils import timezone

from questions.models import Question


class Exam(models.Model):
    """
    A single mock-exam attempt by a user (this doubles as the
    "UserExamResults" record described in the spec: exam_category,
    language_used, score, total_questions and date_taken map directly to
    `category`, `language_used`, `score`, `total_questions` and
    `submitted_at` below; the extra fields support running the exam as a
    live session rather than just storing a final tally).
    """

    class Category(models.TextChoices):
        STUDENT = "student", "Student"
        NON_PROFESSIONAL = "non_professional", "Non-Professional"
        PROFESSIONAL = "professional", "Professional"

    class Language(models.TextChoices):
        ENGLISH = "en", "English"
        FILIPINO = "ph", "Filipino"
        HILIGAYNON = "hl", "Hiligaynon"

    class Status(models.TextChoices):
        IN_PROGRESS = "in_progress", "In progress"
        COMPLETED = "completed", "Completed"
        ABANDONED = "abandoned", "Abandoned"

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="exams")
    category = models.CharField(max_length=20, choices=Category.choices)
    language_used = models.CharField(max_length=2, choices=Language.choices, default=Language.ENGLISH)

    total_questions = models.PositiveIntegerField()
    time_limit_minutes = models.PositiveIntegerField(null=True, blank=True, help_text="Optional timer; blank = untimed.")

    status = models.CharField(max_length=15, choices=Status.choices, default=Status.IN_PROGRESS)
    score = models.PositiveIntegerField(default=0)

    started_at = models.DateTimeField(auto_now_add=True)
    submitted_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "user_exam_results"
        ordering = ["-started_at"]

    def __str__(self):
        return f"{self.user.email} - {self.get_category_display()} ({self.started_at:%Y-%m-%d})"

    @property
    def date_taken(self):
        return self.submitted_at or self.started_at

    @property
    def percentage(self):
        if not self.total_questions:
            return 0
        return round((self.score / self.total_questions) * 100, 1)

    @property
    def is_expired(self):
        if not self.time_limit_minutes or self.status != self.Status.IN_PROGRESS:
            return False
        deadline = self.started_at + timezone.timedelta(minutes=self.time_limit_minutes)
        return timezone.now() > deadline

    @classmethod
    def build_question_set(cls, category, num_questions):
        """Selects a random, active question set for the given category,
        falling back to include category='all' questions in the pool."""
        pool = Question.objects.filter(is_active=True).filter(
            models.Q(category=category) | models.Q(category=Question.Category.ALL)
        )
        ids = list(pool.values_list("id", flat=True))
        random.shuffle(ids)
        return ids[:num_questions]


class ExamResponse(models.Model):
    """One question presented within an Exam session, and (once answered)
    the examinee's selected option and whether it was correct."""

    exam = models.ForeignKey(Exam, on_delete=models.CASCADE, related_name="responses")
    question = models.ForeignKey(Question, on_delete=models.PROTECT, related_name="responses")
    order = models.PositiveIntegerField()

    selected_answer = models.CharField(max_length=1, choices=Question.Answer.choices, null=True, blank=True)
    is_correct = models.BooleanField(null=True, blank=True)
    answered_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = "exam_responses"
        ordering = ["exam_id", "order"]
        unique_together = [("exam", "question")]
