import json
import logging
import boto3
import os
import secrets
from django.db import IntegrityError
from django.forms import ValidationError
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import logout, login
from django.contrib.auth.hashers import check_password
import firebase_admin
from firebase_admin import auth
from .models import FirebaseUser, Archivo, Tramite

from functools import wraps

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

# Required token decorator
def token_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        token = request.headers.get('X-Auth-Token')
        if not token:
            return JsonResponse({"error": "Authorization token missing"}, status=401)

        try:
            request.user = FirebaseUser.objects.get(token=token)
        except FirebaseUser.DoesNotExist:
            return JsonResponse({"error": "Invalid token"}, status=401)
        
        return view_func(request, *args, **kwargs)
    
    return _wrapped_view

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


# Seccion de listado
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
# Lista de usuarios en general
def list_users(request):
    try:
        # Fetch all users from the database
        users = FirebaseUser.objects.all()
        # Create a list of user details
        user_details = [{
            'display_name': user.display_name,
            'email': user.email,
            'uid': user.uid
        } for user in users]

        return JsonResponse({'users': user_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

# Lista de archivos en S3
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

# Lista de tramites
def list_tramites(request):
    try:
        # Fetch all tramites from the database
        tramites = Tramite.objects.all()
        # Create a list of tramite details
        tramite_details = [{
            'id': tramite.id,
            'usuario': tramite.usuario.email,
            'titulo': tramite.titulo,
            'descripcion': tramite.descripcion,
            'estado': tramite.estado,
            'fecha_creacion': tramite.fecha_creacion,
        } for tramite in tramites]

        return JsonResponse({'tramites': tramite_details})
    except Exception as e:
        logger.error(f"Error listing tramites: {str(e)}")
        return JsonResponse({'error': str(e)}, status=500)

# Seccion de pruebas
def create_test_tramite(request):
    try:
        # Fetch the user by email or uid
        user = FirebaseUser.objects.get(email="vicente.ramirez.gonzalez@gmail.com")

        # Create a new Tramite for this user
        tramite = Tramite.objects.create(
            usuario=user,
            titulo="Solicitud de prueba",
            descripcion="Esta es una prueba de tramite para verificar el sistema",
            estado="pendiente"
        )
        logger.info("Creado tramite de prueba con exito")
        return JsonResponse({'message': 'Tramite created successfully', 'tramite_id': tramite.id})
    except FirebaseUser.DoesNotExist:
        logger.error("User not found")
        return JsonResponse({'error': 'User not found'}, status=404)
    except Exception as e:
        logger.error(f"Error creating tramite: {str(e)}")
        return JsonResponse({'error': str(e)}, status=500)


def create_test_user(request):
    # Crear un usuario local sin un uid
    try:
        local_user = FirebaseUser.objects.create(
            uid=None,  # This can be left as None or omitted entirely
            email="localuser@example.com",
            display_name="Local User",
            phone_number="1234567890",
            photo_url=None,
            disabled=False,
            is_local_user=True,  # Mark as a local user
            password="password123"  # Password will be hashed in the model
        )
        return JsonResponse({'message': 'User created successfully', 'user': [local_user.email]})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

# Crear un usuario con los parametros de entrada del usuario, no de google
@csrf_exempt
def create_user(request):
    if request.method == 'POST':
        try:
            # Obtener los datos del usuario
            data = request.POST

            # Validar los datos necesarios
            required_fields = ['email', 'display_name', 'phone_number', 'password']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({'error': f'Missing required field: {field}'}, status=400)

            # Create the user with provided data
            user = FirebaseUser(
                uid=None,
                email=data.get('email'),
                display_name=data.get('display_name'),
                phone_number=data.get('phone_number'),
                photo_url=None,  # Placeholder, can add profile image handling later
                disabled=False,
                is_local_user=True,
                password=data.get('password')  # Password will be hashed in the model
            )

            # Save user and catch unique constraint errors (e.g., email already in use)
            user.save()
            return JsonResponse({'message': 'User created successfully', 'user': user.email})
        
        except IntegrityError:
            return JsonResponse({'error': 'Email already in use'}, status=400)
        
        except ValidationError as e:
            return JsonResponse({'error': str(e)}, status=400)
        
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
# Login de usuario
@csrf_exempt
def login_user(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            
            # Check for required fields
            required_fields = ['email', 'password']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({'error': f'Missing required field: {field}'}, status=400)

            # Attempt to retrieve user
            try:
                user = FirebaseUser.objects.get(email=data['email'])
            except FirebaseUser.DoesNotExist:
                return JsonResponse({'error': 'Invalid email or password'}, status=400)

             # Check password
            password_check = user.check_password(data['password'])

            if password_check:
                # Generate token only if password check succeeds
                token = user.token or secrets.token_hex(16)
                user.token = token
                user.save()
                return JsonResponse({'message': 'Login successful', 'token': token, 'user_id': user.id})
            else:
                return JsonResponse({'error': 'Invalid email or password'}, status=400)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)


@csrf_exempt
def logout_user(request):
    token = request.headers.get('X-Auth-Token')
    if not token:
        return JsonResponse({"error": "Authorization token missing"}, status=401)
    
    try:
        user = FirebaseUser.objects.get(token=token)
        user.token = None  # Clear the token to invalidate the session
        user.save()
        return JsonResponse({"message": "Logout successful"})
    except FirebaseUser.DoesNotExist:
        return JsonResponse({"error": "Invalid token"}, status=401)

@csrf_exempt
@token_required
def get_user_details(request):
    try:
        user = request.user
        # Confirm user retrieval by token
        # print(f"User found for token: {user.email}")  
        user_data = {
            "id": user.id,
            "email": user.email,
            "display_name": user.display_name,
        }
        return JsonResponse(user_data)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    
@csrf_exempt
def delete_user(request):
    if request.method == 'DELETE':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            if not email:
                return JsonResponse({'error': 'Email is required'}, status=400)

            try:
                user = FirebaseUser.objects.get(email=email)
                user.delete()
                return JsonResponse({'message': 'User deleted successfully'})
            except FirebaseUser.DoesNotExist:
                return JsonResponse({'error': 'User not found'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)