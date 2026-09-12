from django.urls import path

from . import views

app_name = "exams"

urlpatterns = [
    path("start", views.StartExamView.as_view(), name="start"),
    path("submit", views.SubmitExamView.as_view(), name="submit"),
    path("results/<int:exam_id>", views.ExamResultView.as_view(), name="results"),
    path("history", views.ExamHistoryView.as_view(), name="history"),
]
