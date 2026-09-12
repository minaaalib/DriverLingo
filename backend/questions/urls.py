from django.urls import path
from rest_framework.routers import DefaultRouter

from .views import BulkQuestionUploadView, QuestionViewSet

app_name = "questions"

router = DefaultRouter()
router.register("", QuestionViewSet, basename="question")

urlpatterns = [
    # Must precede the router include so "bulk-upload" isn't swallowed by
    # the "<pk>/" detail route.
    path("bulk-upload", BulkQuestionUploadView.as_view(), name="bulk-upload"),
] + router.urls
