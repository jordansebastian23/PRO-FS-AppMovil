from django.shortcuts import render
from django.http import JsonResponse
import firebase_admin
from firebase_admin import auth
from .models import FirebaseUser

# Create your views here.

# Cambiar nombre de la vista
def my_view(request):
    if request.user:
        return JsonResponse({'message': 'Authenticated', 'user': request.user})
    else:
        return JsonResponse({'message': 'Not authenticated'}, status=401)

# lista de usuarios de Firebase
def list_firebase_users(request):
    try:
        users = []
        # Iterate through all users
        for user in auth.list_users().iterate_all():
            users.append({
                'uid': user.uid,
                'email': user.email,
                'display_name': user.display_name,
                'phone_number': user.phone_number,
                'photo_url': user.photo_url,
                'disabled': user.disabled,  
            })
        return JsonResponse({'users': users})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
# Migrar usuarios desde Firebase
def migrate_firebase_users(request):
    try:
        users = []
        # Iterate through all users
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
                firebase_user.email = user.email,
                firebase_user.display_name = user.display_name
                firebase_user.phone_number = user.phone_number
                firebase_user.photo_url = user.photo_url
                firebase_user.disabled = user.disabled
                firebase_user.save()
            users.append(firebase_user)
        return JsonResponse({'message': 'Users migrated successfully', 'users': [user.uid for user in users]})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)