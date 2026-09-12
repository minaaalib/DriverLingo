from rest_framework import generics, permissions

from .serializers import FeedbackSerializer


class FeedbackCreateView(generics.CreateAPIView):
    """POST /api/feedback - submit user feedback (bug report, content
    correction, suggestion). Anonymous submissions are allowed since a
    user who isn't sure their exam category/language is right shouldn't
    be blocked from reporting it."""

    serializer_class = FeedbackSerializer
    permission_classes = [permissions.AllowAny]
