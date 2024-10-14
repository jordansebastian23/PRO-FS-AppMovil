from django.core.management.base import BaseCommand
from firebase_admin import auth
from ...models import FirebaseUser

class Command(BaseCommand):
    help = 'Migrate Firebase users to PostgreSQL'

    def handle(self, *args, **kwargs):
        try:
            users = []
            for user in auth.list_users().iterate_all():
                firebase_user, created = FirebaseUser.objects.get_or_create(
                    uid=user.uid,
                    defaults={
                        'email': user.email,
                        'display_name': user.display_name,
                        'phone_number': user.phone_number,
                        'photo_url': user.photo_url,
                        'disabled': user.disabled,
                    }
                )
                if not created:
                    firebase_user.email = user.email
                    firebase_user.display_name = user.display_name
                    firebase_user.phone_number = user.phone_number
                    firebase_user.photo_url = user.photo_url
                    firebase_user.disabled = user.disabled
                    firebase_user.save()
                users.append(firebase_user)
            self.stdout.write(self.style.SUCCESS('Users migrated successfully'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'Error: {str(e)}'))