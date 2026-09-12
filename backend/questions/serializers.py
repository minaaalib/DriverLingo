from rest_framework import serializers

from .models import Question

LANGUAGE_SUFFIX = {"en": "en", "english": "en", "ph": "ph", "fil": "ph", "filipino": "ph", "hl": "hl", "hiligaynon": "hl"}


class QuestionSerializer(serializers.ModelSerializer):
    """Full representation with every language + the answer key. Used by
    the admin CRUD endpoints and the general read endpoints (this app is a
    *reviewer*, so showing the answer key outside of an active exam is
    intentional - the exams app serves a separate, answer-hidden payload
    while a mock exam is in progress)."""

    class Meta:
        model = Question
        fields = [
            "id",
            "question_en",
            "question_ph",
            "question_hl",
            "question_photo",
            "option_a_en",
            "option_a_ph",
            "option_a_hl",
            "option_a_photo",
            "option_b_en",
            "option_b_ph",
            "option_b_hl",
            "option_b_photo",
            "option_c_en",
            "option_c_ph",
            "option_c_hl",
            "option_c_photo",
            "correct_answer",
            "explanation_en",
            "explanation_ph",
            "explanation_hl",
            "category",
            "is_active",
            "needs_review",
            "created_at",
            "updated_at",
        ]
        read_only_fields = ["id", "created_at", "updated_at"]

    def validate(self, attrs):
        # On create, all three options are required (even if translations
        # are filled in later); on partial update we don't re-require them.
        if self.instance is None:
            for field in ("question_en", "option_a_en", "option_b_en", "option_c_en"):
                if not (attrs.get(field) or "").strip():
                    raise serializers.ValidationError({field: "This field is required."})
        return attrs


class LocalizedQuestionSerializer(serializers.ModelSerializer):
    """Collapses the per-language fields down to a single set based on a
    `?lang=` query param (en/ph/hl), which is what the mobile app consumes
    once the user has picked a study/exam language."""

    question = serializers.SerializerMethodField()
    question_photo = serializers.ImageField(read_only=True)
    option_a = serializers.SerializerMethodField()
    option_b = serializers.SerializerMethodField()
    option_c = serializers.SerializerMethodField()
    explanation = serializers.SerializerMethodField()

    class Meta:
        model = Question
        fields = [
            "id",
            "question",
            "question_photo",
            "option_a",
            "option_a_photo",
            "option_b",
            "option_b_photo",
            "option_c",
            "option_c_photo",
            "correct_answer",
            "explanation",
            "category",
            "needs_review",
        ]

    def _lang(self):
        request = self.context.get("request")
        raw = (request.query_params.get("lang") if request else None) or "en"
        return LANGUAGE_SUFFIX.get(raw.lower(), "en")

    def get_question(self, obj):
        return getattr(obj, f"question_{self._lang()}") or obj.question_en

    def get_option_a(self, obj):
        return getattr(obj, f"option_a_{self._lang()}") or obj.option_a_en

    def get_option_b(self, obj):
        return getattr(obj, f"option_b_{self._lang()}") or obj.option_b_en

    def get_option_c(self, obj):
        return getattr(obj, f"option_c_{self._lang()}") or obj.option_c_en

    def get_explanation(self, obj):
        return getattr(obj, f"explanation_{self._lang()}") or obj.explanation_en


class BulkQuestionRowSerializer(serializers.ModelSerializer):
    """One row of a bulk-upload payload. `question_photo_key` /
    `option_*_photo_key` let a row reference an uploaded file by form
    field name so images can travel alongside the JSON in one multipart
    request (see BulkUploadSerializer)."""

    question_photo_key = serializers.CharField(required=False, allow_blank=True)
    option_a_photo_key = serializers.CharField(required=False, allow_blank=True)
    option_b_photo_key = serializers.CharField(required=False, allow_blank=True)
    option_c_photo_key = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = Question
        fields = [
            "question_en",
            "question_ph",
            "question_hl",
            "question_photo_key",
            "option_a_en",
            "option_a_ph",
            "option_a_hl",
            "option_a_photo_key",
            "option_b_en",
            "option_b_ph",
            "option_b_hl",
            "option_b_photo_key",
            "option_c_en",
            "option_c_ph",
            "option_c_hl",
            "option_c_photo_key",
            "correct_answer",
            "explanation_en",
            "explanation_ph",
            "explanation_hl",
            "category",
        ]
