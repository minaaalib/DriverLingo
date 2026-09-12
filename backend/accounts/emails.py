"""Transactional email helpers: registration verification, password reset,
and exam completion notices."""

from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string


def _send(subject, template_name, context, to_email):
    message = render_to_string(template_name, context)
    send_mail(
        subject=subject,
        message=message,
        from_email=settings.DEFAULT_FROM_EMAIL,
        recipient_list=[to_email],
        fail_silently=False,
    )


def send_verification_email(user, token):
    verify_url = f"{settings.FRONTEND_BASE_URL}/api/auth/verify-email/{token}/"
    _send(
        subject="Verify your LTO Exam Reviewer account",
        template_name="emails/verify_email.txt",
        context={"user": user, "verify_url": verify_url, "token": token},
        to_email=user.email,
    )


def send_password_reset_email(user, token):
    reset_url = f"{settings.FRONTEND_BASE_URL}/api/auth/password-reset/confirm/?token={token}"
    _send(
        subject="Reset your LTO Exam Reviewer password",
        template_name="emails/password_reset.txt",
        context={"user": user, "reset_url": reset_url, "token": token},
        to_email=user.email,
    )


def send_exam_completed_email(exam):
    user = exam.user
    _send(
        subject="Your LTO mock exam results are in",
        template_name="emails/exam_completed.txt",
        context={"user": user, "exam": exam},
        to_email=user.email,
    )
