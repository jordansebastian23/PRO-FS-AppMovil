import logging
import boto3
import os
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
import firebase_admin
from firebase_admin import auth
from .models import FirebaseUser
# Configurar el logger
logger = logging.getLogger(__name__)

# Configurar el cliente de S3
s3_client = boto3.client(
    's3',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
    region_name=os.getenv('AWS_S3_REGION_NAME')
)

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
    
@csrf_exempt
def upload_file(request):
    if request.method == 'POST' and request.FILES.get('file'):
        try:
            file = request.FILES['file']
            file_name = file.name
            file_content = file.read()

            # Subir el archivo a S3
            bucket_name = os.getenv('AWS_STORAGE_BUCKET_NAME')
            s3_client.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)

            file_url = f"https://{bucket_name}.s3.amazonaws.com/{file_name}"
            logger.info(f"File saved to S3: {file_url}")
            return JsonResponse({'file_url': file_url}, status=201)
        except Exception as e:
            logger.error(f"Error saving file to S3: {str(e)}")
            return JsonResponse({'error': str(e)}, status=500)
    logger.warning("Invalid request: No file found in request")
    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
def list_files(request):
    try:
        bucket_name = os.getenv('AWS_STORAGE_BUCKET_NAME')
        response = s3_client.list_objects_v2(Bucket=bucket_name)
        files = [obj['Key'] for obj in response.get('Contents', [])]
        return JsonResponse({'files': files}, status=200)
    except Exception as e:
        logger.error(f"Error listing files in S3: {str(e)}")
        return JsonResponse({'error': str(e)}, status=500)
