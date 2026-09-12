from django.conf import settings
from rest_framework import serializers

from questions.models import Question
from questions.serializers import LANGUAGE_SUFFIX

from .models import Exam, ExamResponse


class StartExamSerializer(serializers.Serializer):
    category = serializers.ChoiceField(choices=Exam.Category.choices)
    language = serializers.ChoiceField(choices=Exam.Language.choices, default=Exam.Language.ENGLISH)
    num_questions = serializers.IntegerField(required=False, min_value=1, max_value=200)
    time_limit_minutes = serializers.IntegerField(required=False, min_value=1, max_value=180, allow_null=True)

    def validate(self, attrs):
        if "num_questions" not in attrs:
            attrs["num_questions"] = settings.EXAM_STANDARD_QUESTION_COUNTS.get(attrs["category"], 40)
        return attrs


class ExamQuestionSerializer(serializers.ModelSerializer):
    """What the mobile app receives while an exam is IN PROGRESS: the
    question/options in the chosen language, with no answer key and no
    explanation, so the client can't cheat by reading the response body.

    Also includes every language's text for the question/options (but
    *not* the explanation, which stays hidden until submission) so the
    app can offer an in-place translate toggle without extra requests or
    any risk of leaking the answer key."""

    question_id = serializers.IntegerField(source="question.id")
    order = serializers.IntegerField()
    question = serializers.SerializerMethodField()
    question_photo = serializers.SerializerMethodField()
    option_a = serializers.SerializerMethodField()
    option_a_photo = serializers.SerializerMethodField()
    option_b = serializers.SerializerMethodField()
    option_b_photo = serializers.SerializerMethodField()
    option_c = serializers.SerializerMethodField()
    option_c_photo = serializers.SerializerMethodField()
    selected_answer = serializers.CharField(read_only=True)
    translations = serializers.SerializerMethodField()

    class Meta:
        model = ExamResponse
        fields = [
            "question_id",
            "order",
            "question",
            "question_photo",
            "option_a",
            "option_a_photo",
            "option_b",
            "option_b_photo",
            "option_c",
            "option_c_photo",
            "selected_answer",
            "translations",
        ]

    def _lang(self):
        exam = self.context["exam"]
        return LANGUAGE_SUFFIX.get(exam.language_used, "en")

    def get_translations(self, obj):
        q = obj.question
        return {
            "en": {"question": q.question_en, "option_a": q.option_a_en, "option_b": q.option_b_en, "option_c": q.option_c_en},
            "ph": {
                "question": q.question_ph or q.question_en,
                "option_a": q.option_a_ph or q.option_a_en,
                "option_b": q.option_b_ph or q.option_b_en,
                "option_c": q.option_c_ph or q.option_c_en,
            },
            "hl": {
                "question": q.question_hl or q.question_en,
                "option_a": q.option_a_hl or q.option_a_en,
                "option_b": q.option_b_hl or q.option_b_en,
                "option_c": q.option_c_hl or q.option_c_en,
            },
        }

    def _photo_url(self, image_field):
        if not image_field:
            return None
        request = self.context.get("request")
        return request.build_absolute_uri(image_field.url) if request else image_field.url

    def get_question(self, obj):
        return getattr(obj.question, f"question_{self._lang()}") or obj.question.question_en

    def get_question_photo(self, obj):
        return self._photo_url(obj.question.question_photo)

    def get_option_a(self, obj):
        return getattr(obj.question, f"option_a_{self._lang()}") or obj.question.option_a_en

    def get_option_a_photo(self, obj):
        return self._photo_url(obj.question.option_a_photo)

    def get_option_b(self, obj):
        return getattr(obj.question, f"option_b_{self._lang()}") or obj.question.option_b_en

    def get_option_b_photo(self, obj):
        return self._photo_url(obj.question.option_b_photo)

    def get_option_c(self, obj):
        return getattr(obj.question, f"option_c_{self._lang()}") or obj.question.option_c_en

    def get_option_c_photo(self, obj):
        return self._photo_url(obj.question.option_c_photo)


class ExamSerializer(serializers.ModelSerializer):
    percentage = serializers.ReadOnlyField()
    date_taken = serializers.ReadOnlyField()

    class Meta:
        model = Exam
        fields = [
            "id",
            "category",
            "language_used",
            "total_questions",
            "time_limit_minutes",
            "status",
            "score",
            "percentage",
            "started_at",
            "submitted_at",
            "date_taken",
        ]
        read_only_fields = fields


class SubmitAnswerSerializer(serializers.Serializer):
    question_id = serializers.IntegerField()
    selected_answer = serializers.ChoiceField(choices=Question.Answer.choices, allow_null=True, required=False)


class SubmitExamSerializer(serializers.Serializer):
    exam_id = serializers.IntegerField()
    answers = SubmitAnswerSerializer(many=True)
    time_taken_seconds = serializers.IntegerField(required=False, min_value=0)


class ExamResultResponseSerializer(serializers.ModelSerializer):
    """Per-question breakdown shown on the results screen, after
    submission - this is where the answer key and explanation are safe to
    reveal."""

    question_id = serializers.IntegerField(source="question.id")
    question = serializers.SerializerMethodField()
    option_a = serializers.SerializerMethodField()
    option_b = serializers.SerializerMethodField()
    option_c = serializers.SerializerMethodField()
    correct_answer = serializers.CharField(source="question.correct_answer")
    explanation = serializers.SerializerMethodField()
    translations = serializers.SerializerMethodField()

    class Meta:
        model = ExamResponse
        fields = [
            "question_id",
            "order",
            "question",
            "option_a",
            "option_b",
            "option_c",
            "selected_answer",
            "correct_answer",
            "is_correct",
            "explanation",
            "translations",
        ]

    def _lang(self):
        exam = self.context["exam"]
        return LANGUAGE_SUFFIX.get(exam.language_used, "en")

    def get_question(self, obj):
        return getattr(obj.question, f"question_{self._lang()}") or obj.question.question_en

    def get_option_a(self, obj):
        return getattr(obj.question, f"option_a_{self._lang()}") or obj.question.option_a_en

    def get_option_b(self, obj):
        return getattr(obj.question, f"option_b_{self._lang()}") or obj.question.option_b_en

    def get_option_c(self, obj):
        return getattr(obj.question, f"option_c_{self._lang()}") or obj.question.option_c_en

    def get_explanation(self, obj):
        return getattr(obj.question, f"explanation_{self._lang()}") or obj.question.explanation_en

    def get_translations(self, obj):
        """Every language's question/options/explanation, so the results
        screen can offer the same in-place translate toggle the in-progress
        exam has — the answer key is already revealed here, so there's no
        leakage risk in shipping every language up front."""
        q = obj.question
        return {
            "en": {
                "question": q.question_en,
                "option_a": q.option_a_en,
                "option_b": q.option_b_en,
                "option_c": q.option_c_en,
                "explanation": q.explanation_en,
            },
            "ph": {
                "question": q.question_ph or q.question_en,
                "option_a": q.option_a_ph or q.option_a_en,
                "option_b": q.option_b_ph or q.option_b_en,
                "option_c": q.option_c_ph or q.option_c_en,
                "explanation": q.explanation_ph or q.explanation_en,
            },
            "hl": {
                "question": q.question_hl or q.question_en,
                "option_a": q.option_a_hl or q.option_a_en,
                "option_b": q.option_b_hl or q.option_b_en,
                "option_c": q.option_c_hl or q.option_c_en,
                "explanation": q.explanation_hl or q.explanation_en,
            },
        }


class ExamResultSerializer(ExamSerializer):
    responses = serializers.SerializerMethodField()

    class Meta(ExamSerializer.Meta):
        fields = ExamSerializer.Meta.fields + ["responses"]

    def get_responses(self, obj):
        qs = obj.responses.select_related("question").order_by("order")
        return ExamResultResponseSerializer(qs, many=True, context={**self.context, "exam": obj}).data
