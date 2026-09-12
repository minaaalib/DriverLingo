from django.http import HttpResponse
from rest_framework import permissions
from rest_framework.views import APIView

from questions.models import Question

from .pdf import build_reviewer_pdf


class ReviewerPDFView(APIView):
    """GET /api/reviewer/pdf?lang=hl&category=professional

    Generates a printable PDF reviewer of the (active) question bank in
    the requested language, optionally scoped to one exam category.
    Query params:
      - lang: en | ph | hl (default en)
      - category: student | non_professional | professional | all (default: all)
    """

    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        lang = request.query_params.get("lang", "en")
        category = request.query_params.get("category")

        questions = Question.objects.filter(is_active=True).order_by("id")
        if category and category != "all":
            questions = questions.filter(category__in=[category, Question.Category.ALL])

        pdf_bytes = build_reviewer_pdf(questions, lang=lang, category=category)

        response = HttpResponse(pdf_bytes, content_type="application/pdf")
        filename = f"lto-reviewer-{lang}" + (f"-{category}" if category else "") + ".pdf"
        response["Content-Disposition"] = f'attachment; filename="{filename}"'
        return response
