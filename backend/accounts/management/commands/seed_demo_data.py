from django.core.management.base import BaseCommand
from django.utils import timezone

from accounts.models import User


class Command(BaseCommand):
    help = "Creates a demo admin account and a demo examinee account for local testing."

    def handle(self, *args, **options):
        admin, created = User.objects.get_or_create(
            email="admin@ltoreviewer.local",
            defaults={
                "name": "Admin",
                "role": User.Role.ADMIN,
                "is_staff": True,
                "is_superuser": True,
                "email_verified_at": timezone.now(),
            },
        )
        if created:
            admin.set_password("Admin@12345")
            admin.save()
            self.stdout.write(self.style.SUCCESS("Created admin@ltoreviewer.local / Admin@12345"))
        else:
            self.stdout.write("Admin account already exists.")

        demo_user, created = User.objects.get_or_create(
            email="examinee@ltoreviewer.local",
            defaults={
                "name": "Juan Dela Cruz",
                "role": User.Role.USER,
                "email_verified_at": timezone.now(),
            },
        )
        if created:
            demo_user.set_password("Examinee@12345")
            demo_user.save()
            self.stdout.write(self.style.SUCCESS("Created examinee@ltoreviewer.local / Examinee@12345"))
        else:
            self.stdout.write("Demo examinee account already exists.")
