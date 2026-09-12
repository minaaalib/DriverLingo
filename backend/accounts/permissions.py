from rest_framework.permissions import SAFE_METHODS, BasePermission


class IsAdminRole(BasePermission):
    """Allows access only to users whose role is 'admin' (or Django superusers)."""

    message = "Only administrators may perform this action."

    def has_permission(self, request, view):
        user = request.user
        return bool(user and user.is_authenticated and (user.is_admin or user.is_superuser))


class IsAdminOrReadOnly(BasePermission):
    """Anyone authenticated may read; only admins may write."""

    message = "Only administrators may modify this resource."

    def has_permission(self, request, view):
        if not (request.user and request.user.is_authenticated):
            return False
        if request.method in SAFE_METHODS:
            return True
        return bool(request.user.is_admin or request.user.is_superuser)


class IsSelfOrAdmin(BasePermission):
    """Object-level permission: the owner of the object, or an admin."""

    def has_object_permission(self, request, view, obj):
        user = request.user
        owner = getattr(obj, "user", obj)
        return bool(user.is_admin or user.is_superuser or owner == user)
