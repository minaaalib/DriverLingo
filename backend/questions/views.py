import json

from django.core.files.uploadedfile import UploadedFile
from rest_framework import status, viewsets
from rest_framework.parsers import FormParser, JSONParser, MultiPartParser
from rest_framework.response import Response
from rest_framework.views import APIView

from accounts.permissions import IsAdminOrReadOnly
from .models import Question
from .serializers import (
    BulkQuestionRowSerializer,
    LocalizedQuestionSerializer,
    QuestionSerializer,
)


class QuestionViewSet(viewsets.ModelViewSet):
    """
    GET    /api/questions            - list (filter by ?lang=, ?category=, ?search=)
    GET    /api/questions/{id}       - retrieve
    POST   /api/questions            - create (admin only)
    PUT    /api/questions/{id}       - update (admin only)
    PATCH  /api/questions/{id}       - partial update (admin only)
    DELETE /api/questions/{id}       - delete (admin only)
    """

    queryset = Question.objects.filter(is_active=True).order_by("id")
    permission_classes = [IsAdminOrReadOnly]
    filterset_fields = ["category", "needs_review"]
    search_fields = ["question_en", "question_ph", "question_hl"]
    ordering_fields = ["id", "created_at"]
    parser_classes = [MultiPartParser, FormParser, JSONParser]

    def get_queryset(self):
        qs = Question.objects.all().order_by("id")
        # Admins managing content should see inactive/flagged items too;
        # everyone else only sees the live question bank.
        user = self.request.user
        if not (user.is_authenticated and (user.is_admin or user.is_superuser)):
            qs = qs.filter(is_active=True)
        return qs

    def get_serializer_class(self):
        if self.action in ("list", "retrieve") and self.request.query_params.get("lang"):
            return LocalizedQuestionSerializer
        return QuestionSerializer

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class BulkQuestionUploadView(APIView):
    """
    POST /api/questions/bulk-upload

    Admin-only. Accepts a multipart/form-data request with:
      - `questions`: a JSON array string of question rows (see
        BulkQuestionRowSerializer for the shape of each row). A row may
        reference an uploaded image by including e.g.
        "question_photo_key": "q1_photo" where "q1_photo" is the form
        field name of an attached file in the same request.
      - any number of image files, each attached under the key referenced
        by a row's `*_photo_key`.

    Also accepts a plain `application/json` array body with no images,
    for convenience when bulk-loading text-only content.
    """

    permission_classes = [IsAdminOrReadOnly]
    parser_classes = [MultiPartParser, FormParser, JSONParser]

    def post(self, request):
        if isinstance(request.data, list):
            rows = request.data
            files = {}
        else:
            raw_rows = request.data.get("questions")
            if raw_rows is None:
                return Response(
                    {"detail": "Provide a 'questions' field containing a JSON array of question rows."},
                    status=status.HTTP_400_BAD_REQUEST,
                )
            try:
                rows = json.loads(raw_rows) if isinstance(raw_rows, str) else raw_rows
            except json.JSONDecodeError:
                return Response({"detail": "'questions' must be valid JSON."}, status=status.HTTP_400_BAD_REQUEST)
            files = {k: v for k, v in request.data.items() if isinstance(v, UploadedFile)}

        if not isinstance(rows, list) or not rows:
            return Response({"detail": "'questions' must be a non-empty JSON array."}, status=status.HTTP_400_BAD_REQUEST)

        created, errors = [], []
        photo_field_map = {
            "question_photo_key": "question_photo",
            "option_a_photo_key": "option_a_photo",
            "option_b_photo_key": "option_b_photo",
            "option_c_photo_key": "option_c_photo",
        }

        for index, row in enumerate(rows):
            serializer = BulkQuestionRowSerializer(data=row)
            if not serializer.is_valid():
                errors.append({"index": index, "errors": serializer.errors})
                continue

            data = dict(serializer.validated_data)
            photo_kwargs = {}
            for key_field, model_field in photo_field_map.items():
                key = data.pop(key_field, None)
                if key:
                    file_obj = files.get(key)
                    if file_obj is None:
                        errors.append({"index": index, "errors": {key_field: f"No uploaded file found for key '{key}'."}})
                        continue
                    photo_kwargs[model_field] = file_obj

            question = Question.objects.create(created_by=request.user, **data, **photo_kwargs)
            created.append(question.id)

        return Response(
            {
                "created_count": len(created),
                "created_ids": created,
                "error_count": len(errors),
                "errors": errors,
            },
            status=status.HTTP_207_MULTI_STATUS if errors else status.HTTP_201_CREATED,
        )
