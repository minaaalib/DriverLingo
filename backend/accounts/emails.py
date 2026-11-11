"""Transactional email helpers: registration verification, password reset,
and exam completion notices."""

import logging
import threading

from django.conf import settings
from django.core.mail import send_mail
from django.template.loader import render_to_string

logger = logging.getLogger(__name__)


def _send(subject, template_name, context, to_email):
    # Template rendering is local and fast, so do it inline - a bad template
    # should still raise immediately. The actual SMTP delivery is a network
    # call that can take seconds, so it runs on a background thread instead
    # of blocking the request/response cycle (e.g. login, registration,
    # exam submission).
    message = render_to_string(template_name, context)

    def _deliver():
        try:
            send_mail(
                subject=subject,
                message=message,
                from_email=settings.DEFAULT_FROM_EMAIL,
                recipient_list=[to_email],
                fail_silently=False,
            )
        except Exception:
            logger.exception("Failed to send email %r to %s", subject, to_email)

    threading.Thread(target=_deliver, daemon=True).start()


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
