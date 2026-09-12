from rest_framework import serializers

from .models import Feedback


class FeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feedback
        fields = ["id", "category", "message", "related_question", "is_resolved", "created_at"]
        read_only_fields = ["id", "is_resolved", "created_at"]

    def create(self, validated_data):
        request = self.context["request"]
        user = request.user if request.user.is_authenticated else None
        return Feedback.objects.create(user=user, **validated_data)
