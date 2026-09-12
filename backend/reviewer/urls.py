from django.urls import path

from .views import ReviewerPDFView

app_name = "reviewer"

urlpatterns = [
    path("pdf", ReviewerPDFView.as_view(), name="pdf"),
]
