"""
URL configuration for the LTO Exam Reviewer Mobile App backend.
"""

from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

from accounts.views import UserManagementViewSet
from rest_framework.routers import DefaultRouter

users_router = DefaultRouter()
users_router.register("", UserManagementViewSet, basename="user")

urlpatterns = [
    path("admin/", admin.site.urls),
    # --- Auth -----------------------------------------------------------
    path("api/auth/", include("accounts.urls")),
    # --- Question bank ----------------------------------------------------
    path("api/questions/", include("questions.urls")),
    # --- Mock exams -------------------------------------------------------
    path("api/exams/", include("exams.urls")),
    # --- Admin user management --------------------------------------------
    path("api/users/", include((users_router.urls, "users"))),
    # --- Reviewer PDF export -----------------------------------------------
    path("api/reviewer/", include("reviewer.urls")),
    # --- Feedback ----------------------------------------------------------
    path("api/feedback", include("feedback.urls")),
    # --- API schema / docs --------------------------------------------------
    path("api/schema", SpectacularAPIView.as_view(), name="schema"),
    path("api/docs", SpectacularSwaggerView.as_view(url_name="schema"), name="swagger-ui"),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
