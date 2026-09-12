"""Generates a printable PDF of the reviewer material (questions, options,
correct answers, and explanations) in the requested language."""

import io
import os

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import LETTER
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import HRFlowable, Paragraph, SimpleDocTemplate, Spacer

from questions.serializers import LANGUAGE_SUFFIX

FONT_DIR = os.path.join(os.path.dirname(__file__), "fonts")
LANGUAGE_LABELS = {"en": "English", "ph": "Filipino", "hl": "Hiligaynon"}
CATEGORY_LABELS = {
    "student": "Student Permit",
    "non_professional": "Non-Professional",
    "professional": "Professional",
    "all": "All Categories",
}

_FONTS_REGISTERED = False


def _register_fonts():
    global _FONTS_REGISTERED
    if _FONTS_REGISTERED:
        return
    pdfmetrics.registerFont(TTFont("DejaVuSans", os.path.join(FONT_DIR, "DejaVuSans.ttf")))
    pdfmetrics.registerFont(TTFont("DejaVuSans-Bold", os.path.join(FONT_DIR, "DejaVuSans-Bold.ttf")))
    _FONTS_REGISTERED = True


def build_reviewer_pdf(questions, lang="en", category=None):
    """Returns raw PDF bytes for the given queryset of Question objects."""
    _register_fonts()
    suffix = LANGUAGE_SUFFIX.get(lang.lower(), "en")

    buffer = io.BytesIO()
    doc = SimpleDocTemplate(
        buffer,
        pagesize=LETTER,
        topMargin=0.75 * inch,
        bottomMargin=0.75 * inch,
        leftMargin=0.75 * inch,
        rightMargin=0.75 * inch,
        title="LTO Exam Reviewer",
    )

    styles = getSampleStyleSheet()
    title_style = ParagraphStyle(
        "ReviewerTitle", parent=styles["Title"], fontName="DejaVuSans-Bold", alignment=TA_CENTER
    )
    subtitle_style = ParagraphStyle(
        "ReviewerSubtitle", parent=styles["Normal"], fontName="DejaVuSans", alignment=TA_CENTER, textColor=colors.grey
    )
    question_style = ParagraphStyle(
        "Question", parent=styles["Normal"], fontName="DejaVuSans-Bold", fontSize=11, spaceBefore=10, spaceAfter=4
    )
    option_style = ParagraphStyle("Option", parent=styles["Normal"], fontName="DejaVuSans", fontSize=10, leftIndent=14)
    correct_option_style = ParagraphStyle(
        "CorrectOption", parent=option_style, fontName="DejaVuSans-Bold", textColor=colors.HexColor("#1a7f37")
    )
    explanation_style = ParagraphStyle(
        "Explanation",
        parent=styles["Normal"],
        fontName="DejaVuSans",
        fontSize=9,
        leftIndent=14,
        textColor=colors.HexColor("#444444"),
        spaceBefore=4,
    )

    story = [
        Paragraph("LTO Exam Reviewer", title_style),
        Paragraph("with Hiligaynon Translation", subtitle_style),
        Spacer(1, 4),
        Paragraph(
            f"Language: {LANGUAGE_LABELS.get(suffix, 'English')}"
            + (f" &nbsp;&nbsp;|&nbsp;&nbsp; Category: {CATEGORY_LABELS.get(category, category)}" if category else ""),
            subtitle_style,
        ),
        Spacer(1, 12),
        HRFlowable(width="100%", color=colors.grey),
        Spacer(1, 6),
    ]

    for index, q in enumerate(questions, start=1):
        question_text = getattr(q, f"question_{suffix}") or q.question_en
        story.append(Paragraph(f"{index}. {question_text}", question_style))

        for letter in ("a", "b", "c"):
            text = getattr(q, f"option_{letter}_{suffix}") or getattr(q, f"option_{letter}_en")
            style = correct_option_style if letter == q.correct_answer else option_style
            marker = "&#10003;" if letter == q.correct_answer else ""
            story.append(Paragraph(f"{letter}. {text} {marker}", style))

        explanation = getattr(q, f"explanation_{suffix}") or q.explanation_en
        if explanation:
            story.append(Paragraph(f"<i>{explanation}</i>", explanation_style))

        if index % 2 == 0:
            story.append(Spacer(1, 6))
            story.append(HRFlowable(width="100%", color=colors.HexColor("#dddddd")))

    doc.build(story)
    return buffer.getvalue()
