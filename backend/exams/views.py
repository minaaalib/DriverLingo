from django.db import transaction
from django.shortcuts import get_object_or_404
from django.utils import timezone
from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from accounts.emails import send_exam_completed_email
from accounts.permissions import IsSelfOrAdmin
from questions.models import Question

from .models import Exam, ExamResponse
from .serializers import (
    ExamQuestionSerializer,
    ExamResultSerializer,
    ExamSerializer,
    StartExamSerializer,
    SubmitExamSerializer,
)


class StartExamView(APIView):
    """POST /api/exams/start

    Body: {"category": "student|non_professional|professional",
           "language": "en|ph|hl", "num_questions": 40 (optional),
           "time_limit_minutes": 30 (optional)}

    Creates a new in-progress Exam and returns its id plus the selected
    question set (answers withheld).
    """

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        serializer = StartExamSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        question_ids = Exam.build_question_set(data["category"], data["num_questions"])
        if not question_ids:
            return Response(
                {"detail": "No questions are available for this category yet."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        with transaction.atomic():
            exam = Exam.objects.create(
                user=request.user,
                category=data["category"],
                language_used=data["language"],
                total_questions=len(question_ids),
                time_limit_minutes=data.get("time_limit_minutes"),
            )
            questions_by_id = Question.objects.in_bulk(question_ids)
            ExamResponse.objects.bulk_create(
                [
                    ExamResponse(exam=exam, question=questions_by_id[qid], order=index + 1)
                    for index, qid in enumerate(question_ids)
                ]
            )

        responses = exam.responses.select_related("question").order_by("order")
        return Response(
            {
                "exam": ExamSerializer(exam).data,
                "questions": ExamQuestionSerializer(
                    responses, many=True, context={"exam": exam, "request": request}
                ).data,
            },
            status=status.HTTP_201_CREATED,
        )


class SubmitExamView(APIView):
    """POST /api/exams/submit

    Body: {"exam_id": 1, "answers": [{"question_id": 5, "selected_answer": "b"}, ...],
           "time_taken_seconds": 900 (optional)}

    Grades the exam, marks it completed, and emails the user their score.
    """

    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        serializer = SubmitExamSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        exam = get_object_or_404(Exam, pk=data["exam_id"])
        if exam.user_id != request.user.id and not (request.user.is_admin or request.user.is_superuser):
            return Response({"detail": "Not your exam."}, status=status.HTTP_403_FORBIDDEN)
        if exam.status == Exam.Status.COMPLETED:
            return Response({"detail": "This exam has already been submitted."}, status=status.HTTP_400_BAD_REQUEST)

        answers_by_question = {a["question_id"]: a.get("selected_answer") for a in data["answers"]}

        with transaction.atomic():
            responses = list(exam.responses.select_related("question").select_for_update())
            score = 0
            now = timezone.now()
            for response in responses:
                selected = answers_by_question.get(response.question_id)
                response.selected_answer = selected
                if selected is not None:
                    response.is_correct = selected == response.question.correct_answer
                    response.answered_at = now
                    if response.is_correct:
                        score += 1
                else:
                    response.is_correct = None
                response.save(update_fields=["selected_answer", "is_correct", "answered_at"])

            exam.score = score
            exam.status = Exam.Status.COMPLETED
            exam.submitted_at = now
            exam.save(update_fields=["score", "status", "submitted_at"])

        try:
            send_exam_completed_email(exam)
        except Exception:
            # Never fail the exam submission because of an email delivery issue.
            pass

        return Response(ExamResultSerializer(exam, context={"request": request}).data)


class ExamResultView(generics.RetrieveAPIView):
    """GET /api/exams/results/{exam_id} - full breakdown with correct answers."""

    serializer_class = ExamResultSerializer
    permission_classes = [permissions.IsAuthenticated, IsSelfOrAdmin]
    lookup_url_kwarg = "exam_id"

    def get_queryset(self):
        return Exam.objects.select_related("user").prefetch_related("responses__question")


class ExamHistoryView(generics.ListAPIView):
    """GET /api/exams/history - the current user's past exams (newest first)."""

    serializer_class = ExamSerializer
    permission_classes = [permissions.IsAuthenticated]
    filterset_fields = ["category", "status"]
    ordering_fields = ["started_at", "score"]

    def get_queryset(self):
        return Exam.objects.filter(user=self.request.user).order_by("-started_at")
