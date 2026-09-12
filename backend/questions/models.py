from django.conf import settings
from django.db import models


def question_photo_path(instance, filename):
    return f"questions/{instance.pk or 'new'}/question_{filename}"


def option_a_photo_path(instance, filename):
    return f"questions/{instance.pk or 'new'}/option_a_{filename}"


def option_b_photo_path(instance, filename):
    return f"questions/{instance.pk or 'new'}/option_b_{filename}"


def option_c_photo_path(instance, filename):
    return f"questions/{instance.pk or 'new'}/option_c_{filename}"


class Question(models.Model):
    """
    A single LTO reviewer question stored in three languages
    (English, Filipino, Hiligaynon) with up to three answer choices
    (a, b, c), each of which may optionally carry its own image
    (e.g. a road/traffic sign to identify).
    """

    class Category(models.TextChoices):
        ALL = "all", "All categories"
        STUDENT = "student", "Student permit"
        NON_PROFESSIONAL = "non_professional", "Non-Professional"
        PROFESSIONAL = "professional", "Professional"

    class Answer(models.TextChoices):
        A = "a", "A"
        B = "b", "B"
        C = "c", "C"

    # --- Question text & photo, per language --------------------------
    question_en = models.TextField(verbose_name="Question (English)")
    question_ph = models.TextField(verbose_name="Question (Filipino)", blank=True)
    question_hl = models.TextField(verbose_name="Question (Hiligaynon)", blank=True)
    question_photo = models.ImageField(upload_to=question_photo_path, null=True, blank=True)

    # --- Option A --------------------------------------------------------
    option_a_en = models.TextField(verbose_name="Option A (English)")
    option_a_ph = models.TextField(verbose_name="Option A (Filipino)", blank=True)
    option_a_hl = models.TextField(verbose_name="Option A (Hiligaynon)", blank=True)
    option_a_photo = models.ImageField(upload_to=option_a_photo_path, null=True, blank=True)

    # --- Option B --------------------------------------------------------
    option_b_en = models.TextField(verbose_name="Option B (English)")
    option_b_ph = models.TextField(verbose_name="Option B (Filipino)", blank=True)
    option_b_hl = models.TextField(verbose_name="Option B (Hiligaynon)", blank=True)
    option_b_photo = models.ImageField(upload_to=option_b_photo_path, null=True, blank=True)

    # --- Option C --------------------------------------------------------
    option_c_en = models.TextField(verbose_name="Option C (English)")
    option_c_ph = models.TextField(verbose_name="Option C (Filipino)", blank=True)
    option_c_hl = models.TextField(verbose_name="Option C (Hiligaynon)", blank=True)
    option_c_photo = models.ImageField(upload_to=option_c_photo_path, null=True, blank=True)

    correct_answer = models.CharField(max_length=1, choices=Answer.choices)

    # --- Explanations shown after the exam, per language ------------------
    explanation_en = models.TextField(blank=True)
    explanation_ph = models.TextField(blank=True)
    explanation_hl = models.TextField(blank=True)

    category = models.CharField(
        max_length=20,
        choices=Category.choices,
        default=Category.ALL,
        help_text="Which exam category this question may appear in. 'All categories' means it can appear in any mock exam.",
    )

    is_active = models.BooleanField(default=True, help_text="Inactive questions are excluded from new exams.")
    needs_review = models.BooleanField(
        default=False,
        help_text="Flagged for a subject-matter expert to confirm the correct answer before this question is trusted for grading.",
    )

    created_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="created_questions",
    )

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "questions"
        ordering = ["id"]

    def __str__(self):
        return (self.question_en or self.question_ph or self.question_hl)[:80]

    def option_text(self, letter, lang):
        return getattr(self, f"option_{letter}_{lang}")

    def correct_option_text(self, lang="en"):
        return self.option_text(self.correct_answer, lang)
