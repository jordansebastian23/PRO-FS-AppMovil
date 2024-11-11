from datetime import timezone
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
from .models import FirebaseUser, Archivo, Tramite, Roles, Notificaciones, FileType as TipoArchivo, Carga, TramiteFileRequirement as ArchivoRequeridoTramite, Pagos

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

# Google Firebase User Management

# Migrar usuarios desde Firebase
def migrate_firebase_users(request):
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
                    'is_local_user': False,
                    'password': None,  # No password for Google users
                    'token': secrets.token_hex(16)  # Generate a token for Google users
                }
            )
            if not created:
                firebase_user.email = user.email
                firebase_user.display_name = user.display_name
                firebase_user.phone_number = user.phone_number
                firebase_user.photo_url = user.photo_url
                firebase_user.disabled = user.disabled
                firebase_user.is_local_user = False
                firebase_user.password = None  # Ensure no password is set
                if not firebase_user.token:  # Assign a token if none exists
                    firebase_user.token = secrets.token_hex(16)
                firebase_user.save()
            users.append(firebase_user)
        return JsonResponse({'message': 'Users migrated successfully', 'users': [user.uid for user in users]})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

# Obtener o crear un token para un usuario de google, aunque puede ser utilizado para cualquier usuario
@csrf_exempt
def check_or_create_user(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        uid = data.get('uid')
        email = data.get('email')
        display_name = data.get('display_name')
        photo_url = data.get('photo_url')

        if not uid or not email:
            return JsonResponse({'error': 'UID and email are required'}, status=400)

        try:
            user, created = FirebaseUser.objects.get_or_create(
                uid=uid,
                defaults={
                    'email': email,
                    'display_name': display_name,
                    'photo_url': photo_url,
                    'is_local_user': False,  # Mark as Google user
                    'token': secrets.token_hex(16)
                }
            )

            # If user already exists, ensure they have a token
            if not created and not user.token:
                user.token = secrets.token_hex(16)
                user.save()

            # Assign the role to the user, defaulting to 'Tramites'
            role_name = data.get('role', 'Tramites')
            role = Roles.objects.get(nombre=role_name)
            role.id_usuarios.add(user)

            return JsonResponse({'token': user.token})

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
@csrf_exempt
def upload_file(request):
    if request.method == 'POST' and request.FILES.get('file'):
        # Retrieve user from token in headers
        token = request.headers.get('X-Auth-Token')
        if not token:
            return JsonResponse({"error": "Authorization token missing"}, status=401)

        try:
            # Find the user associated with the token
            user = FirebaseUser.objects.get(token=token)
        except FirebaseUser.DoesNotExist:
            return JsonResponse({"error": "Invalid token"}, status=401)

        try:
            data = request.POST
            tramite_id = data.get('tramite_id')
            tipo_archivo_id = data.get('tipo_archivo_id')

            if not tramite_id or not tipo_archivo_id:
                return JsonResponse({"error": "Tramite ID or Tipo Archivo ID missing"}, status=400)

            tramite = Tramite.objects.get(id=tramite_id)
            tipo_archivo = TipoArchivo.objects.get(id=tipo_archivo_id)

            file = request.FILES['file']
            file_name = file.name
            file_content = file.read()

            # Upload the file to S3
            bucket_name = os.getenv('AWS_STORAGE_BUCKET_NAME')
            s3_client.put_object(Bucket=bucket_name, Key=file_name, Body=file_content)

            # Generate the file URL
            file_url = f"https://{bucket_name}.s3.amazonaws.com/{file_name}"
            logger.info(f"File saved to S3: {file_url}")

            # Save file record in the Archivo model
            archivo = Archivo.objects.create(
                usuario=user,
                nombre_archivo=file_name,
                tipo_archivo=file.content_type,
                s3_url=file_url,
                estado_procesamiento='pendiente'  # Default state
            )

            # Link the archivo to the TramiteFileRequirement
            tramite_file_requirement = ArchivoRequeridoTramite.objects.get(tramite=tramite, tipo_archivo=tipo_archivo)
            tramite_file_requirement.archivo = archivo
            tramite_file_requirement.status = 'pending'  # Default state
            tramite_file_requirement.save()

            return JsonResponse({'file_url': file_url, 'archivo_id': archivo.id}, status=201)

        except Tramite.DoesNotExist:
            return JsonResponse({"error": "Tramite not found"}, status=404)
        except TipoArchivo.DoesNotExist:
            return JsonResponse({"error": "Tipo Archivo not found"}, status=404)
        except ArchivoRequeridoTramite.DoesNotExist:
            return JsonResponse({"error": "TramiteFileRequirement not found"}, status=404)
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
            'phone_number': user.phone_number,
            'disabled': user.disabled,
            'roles': [role.nombre for role in user.roles_set.all()],
            'id': user.id
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
    
@csrf_exempt
def list_tramites(request):
    try:
        tramites = Tramite.objects.all()
        tramites_details = [{
            'id': tramite.id,
            'titulo': tramite.titulo,
            'descripcion': tramite.descripcion,
            'usuario_origen': tramite.usuario_origen.email,
            'usuario_destino': tramite.usuario_destino.email,
            'carga_id': tramite.carga.id if tramite.carga else None,
            'fecha_creacion': tramite.fecha_creacion,
            'estado': tramite.estado,
            'fecha_termino': tramite.fecha_termino
        } for tramite in tramites]
        return JsonResponse({'tramites': tramites_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt
def list_notifications(request):
    try:
        notifications = Notificaciones.objects.all()
        notifications_details = [{
            'id': notification.id,
            'titulo': notification.titulo,
            'mensaje': notification.mensaje,
            'origen': notification.id_origen.email,
            'destinos': [user.email for user in notification.id_destino.all()],
            'fecha_creacion': notification.fecha_creacion
        } for notification in notifications]
        return JsonResponse({'notifications': notifications_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt
def user_notifications(request):
    if request.method == 'GET':
        token = request.headers.get('X-Auth-Token')
        if not token:
            return JsonResponse({"error": "Authorization token missing"}, status=401)
        
        try:
            user = FirebaseUser.objects.get(token=token)
            notifications = Notificaciones.objects.filter(id_destino=user)
            notifications_details = [{
                'id': notification.id,
                'titulo': notification.titulo,
                'mensaje': notification.mensaje,
                'fecha_creacion': notification.fecha_creacion
                # Check if its necessary to include the origin user
                # Also, if its needed a status field, for example, 'read' or 'unread'
                # So that if the user reads the notification, it can be marked as read and not shown again
            } for notification in notifications]
            return JsonResponse({'notifications': notifications_details})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({"error": "Invalid token"}, status=401)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)

# Creacion de tramites:
@csrf_exempt
def create_tramite(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        required_fields = ['titulo', 'descripcion', 'usuario_destino', 'carga_id', 'file_type_ids']
        
        for field in required_fields:
            if field not in data:
                return JsonResponse({'error': f'Missing required field: {field}'}, status=400)

        # Retrieve the current user from token
        token = request.headers.get('X-Auth-Token')
        if not token:
            return JsonResponse({"error": "Authorization token missing"}, status=401)

        try:
            # Retrieve the user who creates the tramite
            usuario_origen = FirebaseUser.objects.get(token=token)

            # Get the user who will upload the files (usuario_destino)
            usuario_destino = FirebaseUser.objects.get(email=data['usuario_destino'])

            # Get the carga object
            carga = Carga.objects.get(id=data['carga_id'])

            # Create the Tramite object
            tramite = Tramite.objects.create(
                usuario_origen=usuario_origen,
                usuario_destino=usuario_destino,
                titulo=data['titulo'],
                descripcion=data['descripcion'],
                carga=carga
            )

            # Link selected FileType records to create TramiteFileRequirement
            for file_type_id in data['file_type_ids']:
                file_type = TipoArchivo.objects.get(id=file_type_id)
                ArchivoRequeridoTramite.objects.create(
                    tramite=tramite,
                    tipo_archivo=file_type,
                    status='not_sent'  # Default state
                )

            return JsonResponse({'message': 'Tramite created successfully', 'tramite_id': tramite.id}, status=201)

        except FirebaseUser.DoesNotExist:
            return JsonResponse({"error": "User not found"}, status=404)
        except Carga.DoesNotExist:
            return JsonResponse({"error": "Carga not found"}, status=404)
        except TipoArchivo.DoesNotExist:
            return JsonResponse({"error": "FileType not found"}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)



# def create_test_user(request):
#     # Crear un usuario local sin un uid
#     try:
#         local_user = FirebaseUser.objects.create(
#             uid=None,  # This can be left as None or omitted entirely
#             email="localuser@example.com",
#             display_name="Local User",
#             phone_number="1234567890",
#             photo_url=None,
#             disabled=False,
#             is_local_user=True,  # Mark as a local user
#             password="password123"  # Password will be hashed in the model
#         )
#         return JsonResponse({'message': 'User created successfully', 'user': [local_user.email]})
#     except Exception as e:
#         return JsonResponse({'error': str(e)}, status=500)
    

# Seccion de autenticacion y creacion de usuarios

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

            # Combine the name fields if available (for the web admin version)
            display_name = data.get('display_name')
            if 'apellido_materno' in data and 'apellido_paterno' in data:
                display_name = f"{display_name} {data.get('apellido_paterno', '')} {data.get('apellido_materno', '')}"

            # Create the user
            user = FirebaseUser(
                uid=None,
                email=data.get('email'),
                display_name=display_name,
                phone_number=data.get('phone_number'),
                photo_url=None,  # Placeholder, can add profile image handling later
                disabled=False,
                is_local_user=True,
                password=data.get('password')  # Password will be hashed in the model
            )

            # Save user and catch unique constraint errors (e.g., email already in use)
            user.save()

            # Assign the role to the user, defaulting to 'Tramites'
            role_name = data.get('role', 'Tramites')
            role = Roles.objects.get(nombre=role_name)
            role.id_usuarios.add(user)

            return JsonResponse({'message': 'User created successfully', 'user': user.email})
        
        except IntegrityError:
            return JsonResponse({'error': 'Email already in use'}, status=400)
        
        except ValidationError as e:
            return JsonResponse({'error': str(e)}, status=400)
        
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)

        except Roles.DoesNotExist:
            return JsonResponse({'error': 'Role not found'}, status=404)

        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def edit_user(request):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            if not email:
                return JsonResponse({'error': 'Email is required'}, status=400)

            user = FirebaseUser.objects.get(email=email)

            # Update user fields
            user.display_name = data.get('display_name', user.display_name)
            user.phone_number = data.get('phone_number', user.phone_number)
            user.disabled = data.get('disabled', user.disabled)
            
            user.save()

            # Assign the role to the user, defaulting to 'Tramites'
            role_name = data.get('role', 'Tramites')
            new_role = Roles.objects.get(nombre=role_name)
            
            # Remove user from all current roles
            user.roles_set.clear()
            
            # Add user to the new role
            new_role.id_usuarios.add(user)

            return JsonResponse({'message': 'User updated successfully'})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
        except Roles.DoesNotExist:
            return JsonResponse({'error': 'Role not found'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)


@csrf_exempt
def disable_user(request):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            if not email:
                return JsonResponse({'error': 'Email is required'}, status=400)

            user = FirebaseUser.objects.get(email=email)
            user.disabled = True
            user.save()

            return JsonResponse({'message': 'User disabled successfully'})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
@csrf_exempt
def enable_user(request):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            if not email:
                return JsonResponse({'error': 'Email is required'}, status=400)

            user = FirebaseUser.objects.get(email=email)
            user.disabled = False
            user.save()

            return JsonResponse({'message': 'User enabled successfully'})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

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
            
            # Check if user account is disabled
            if user.disabled:
                return JsonResponse({'error': 'User account is disabled'}, status=403)

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
        # Clear the token only if it's a local user
        if user.is_local_user:
            user.token = None  # Invalidate session for local users
            user.save()
        return JsonResponse({"message": "Logout successful"})
    except FirebaseUser.DoesNotExist:
        return JsonResponse({"error": "Invalid token"}, status=401)

# TODO: Ver como guardar los datos del usuario para que no se llame a la base de datos cada vez

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
            "roles": [role.nombre for role in user.roles_set.all()]
        }
        return JsonResponse(user_data)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    

# The idea is that a user shouldn't be deleted, instead it should be disabled    
# @csrf_exempt
# def delete_user(request):
#     if request.method == 'DELETE':
#         try:
#             data = json.loads(request.body)
#             email = data.get('email')
#             if not email:
#                 return JsonResponse({'error': 'Email is required'}, status=400)

#             try:
#                 user = FirebaseUser.objects.get(email=email)
#                 user.delete()
#                 return JsonResponse({'message': 'User deleted successfully'})
#             except FirebaseUser.DoesNotExist:
#                 return JsonResponse({'error': 'User not found'}, status=404)
#         except json.JSONDecodeError:
#             return JsonResponse({'error': 'Invalid JSON format'}, status=400)
#         except Exception as e:
#             return JsonResponse({'error': str(e)}, status=500)
#     else:
#         return JsonResponse({'error': 'Invalid request method'}, status=405)
    
# Seccion de roles

DEFAULT_ROLES = [
    "Tramites",
    "Conductor",
    "Visado"
]
DESCRIPCIONES = [
    "Rol para la persona que viene a realizar tramites para el retiro de la carga",
    "Rol para la persona que viene a retirar una carga ya tramitada",
    "Rol para la persona encargada de hacer el visado de la carga"
]

# Crear roles predeterminados
# Luego de crear roles, comentar la funcion para evitar crear roles duplicados
# @csrf_exempt
# def create_default_roles(request):
#     if request.method == 'POST':
#         for nombre, descripcion in zip(DEFAULT_ROLES, DESCRIPCIONES):
#             try:
#                 Roles.objects.get_or_create(
#                     nombre=nombre,
#                     defaults={'descripcion': descripcion}
#                 )
#             except Exception as e:
#                 return JsonResponse({'error': str(e)}, status=500)
#         return JsonResponse({'message': 'Default roles created successfully'})

# Crear un rol
# def create_roles(request):
#     if request.method == 'POST':
#         try:
#             data = request.POST
#             required_fields = ['nombre', 'descripcion']
#             for field in required_fields:
#                 if not data.get(field):
#                     return JsonResponse({'error': f'Missing required field: {field}'}, status=400)
#             rol = Roles(
#                 nombre=data.get('nombre'),
#                 descripcion=data.get('descripcion')
#             )

#             rol.save()
#             return JsonResponse({'message': 'Rol creado con exito', 'rol': rol.nombre})
#         except IntegrityError:
#             return JsonResponse({'error': 'Rol ya existe'}, status=400)
#         except ValidationError as e:
#             return JsonResponse({'error': str(e)}, status=400)
#         except json.JSONDecodeError:
#             return JsonResponse({'error': 'Invalid JSON format'}, status=400)
#         except Exception as e:
#             return JsonResponse({'error': str(e)}, status=500)
#     else:
#         return JsonResponse({'error': 'Invalid request method'}, status=405)

# Listar roles
def list_roles(request):
    try:
        roles = Roles.objects.all()
        roles_details = [{
            'nombre': rol.nombre,
            'descripcion': rol.descripcion,
        } for rol in roles]
        return JsonResponse({'roles': roles_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
# Asignar un rol a un usuario
@csrf_exempt
def user_role(request):
    if request.method == 'POST':
        try:
            data = request.POST
            required_fields = ['email']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({'error': f'Missing required field: {field}'}, status=400)
            
            user = FirebaseUser.objects.get(email=data.get('email'))
            
            # Verificar si se especifica un rol, si no, asignar un rol predeterminado
            nombre_rol = data.get('nombre_rol')
            if not nombre_rol:
                nombre_rol = DEFAULT_ROLES[0]  # Asignar el primer rol predeterminado
            
            rol = Roles.objects.get(nombre=nombre_rol)
            rol.id_usuarios.add(user)
            return JsonResponse({'message': f'Usuario {user.email} agregado al rol {rol.nombre}'})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'Usuario no encontrado'}, status=404)
        except Roles.DoesNotExist:
            return JsonResponse({'error': 'Rol no encontrado'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
# Eliminar un rol de un usuario
@csrf_exempt
def delete_user_role(request):
    if request.method == 'DELETE':
        try:
            data = json.loads(request.body)
            email = data.get('email')
            nombre_rol = data.get('nombre_rol')
            if not email or not nombre_rol:
                return JsonResponse({'error': 'Email and role name are required'}, status=400)
            
            user = FirebaseUser.objects.get(email=email)
            rol = Roles.objects.get(nombre=nombre_rol)
            rol.id_usuarios.remove(user)
            return JsonResponse({'message': f'Usuario {user.email} eliminado del rol {rol.nombre}'})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'User not found'}, status=404)
        except Roles.DoesNotExist:
            return JsonResponse({'error': 'Rol not found'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
# Seccion de notificaciones

# Crear una notificacion
@csrf_exempt
def create_notification(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            required_fields = ['titulo', 'mensaje', 'destinos']
            for field in required_fields:
                if field not in data:
                    return JsonResponse({'error': f'Missing required field: {field}'}, status=400)
            
            # Retrieve origin user from token in headers
            token = request.headers.get('X-Auth-Token')
            if not token:
                return JsonResponse({"error": "Authorization token missing"}, status=401)
            
            try:
                user_origen = FirebaseUser.objects.get(token=token)
            except FirebaseUser.DoesNotExist:
                return JsonResponse({"error": "Invalid token"}, status=401)
            
            # Create the notification without destinations first
            notification = Notificaciones.objects.create(
                titulo=data['titulo'],
                mensaje=data['mensaje'],
                id_origen=user_origen
            )

            # Add each destination user to the notification
            destination_emails = data['destinos']  # Expecting 'destinos' to be a list of emails
            for email in destination_emails:
                try:
                    user_destino = FirebaseUser.objects.get(email=email)
                    notification.id_destino.add(user_destino)
                except FirebaseUser.DoesNotExist:
                    return JsonResponse({'error': f'Destination user not found for email: {email}'}, status=404)

            notification.save()
            return JsonResponse({'message': 'Notification created successfully', 'notification_id': notification.id})

        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)

# def create_test_user_with_visado_role(request):
#     try:
#         # Create a local user
#         local_user = FirebaseUser.objects.create(
#             uid=None,
#             email="testvisado@example.com",
#             display_name="Test Visado User",
#             phone_number="1234567890",
#             photo_url=None,
#             disabled=False,
#             is_local_user=True,
#             password="password123"
#         )

#         # Assign the "Visado" role to the user
#         visado_role = Roles.objects.get(nombre="Visado")
#         visado_role.id_usuarios.add(local_user)

#         return JsonResponse({'message': 'Test user with Visado role created successfully', 'user': local_user.email})
#     except Roles.DoesNotExist:
#         return JsonResponse({'error': 'Visado role not found'}, status=404)
#     except Exception as e:
#         return JsonResponse({'error': str(e)}, status=500)

# Seccion de tramites

# Subseccion de creacion de tipos de archivos
DEFAULT_TIPOS_ARCHIVOS = [
    "Boleta de pago",
    "Archivo de retiro",
    "Carnet",
    "Carnet de conductor",
    "Archivo de informacion de aduanas",
    "Archivo de visado"
]
DESCRIPCIONES_TIPOS_ARCHIVOS = [
    "Boleta de pago de la carga",
    "Archivo que acredita el retiro de la carga",
    "Carnet de identidad",
    "Carnet de conductor",
    "Archivo con informacion de aduanas",
    "Archivo con visado de la carga"
]

# # Crear tipos de archivos predeterminados
# @csrf_exempt
# # @token_required
# def create_file_types(request):
#     if request.method == 'POST':
#         for tipo, descripcion in zip(DEFAULT_TIPOS_ARCHIVOS, DESCRIPCIONES_TIPOS_ARCHIVOS):
#             try:
#                 TipoArchivo.objects.get_or_create(
#                     name=tipo,
#                     defaults={'description': descripcion}
#                 )
#             except Exception as e:
#                 return JsonResponse({'error': str(e)}, status=500)
#         return JsonResponse({'message': 'Default file types created successfully'})
    
# Aprovar y rechazar archivos
@csrf_exempt

def approve_archivo(request, archivo_id):
    if request.method == 'POST':
        try:
            archivo = ArchivoRequeridoTramite.objects.get(id=archivo_id)
            archivo.status = 'approved'
            archivo.save()
            return JsonResponse({'message': 'Archivo aprobado exitosamente'}, status=200)
        except ArchivoRequeridoTramite.DoesNotExist:
            return JsonResponse({'error': 'Archivo no encontrado'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método de solicitud no válido'}, status=405)

@csrf_exempt

def reject_archivo(request, archivo_id):
    if request.method == 'POST':
        try:
            archivo = ArchivoRequeridoTramite.objects.get(id=archivo_id)
            archivo.status = 'rejected'
            archivo.feedback = request.POST.get('feedback', '')
            archivo.save()
            return JsonResponse({'message': 'Archivo rechazado exitosamente'}, status=200)
        except ArchivoRequeridoTramite.DoesNotExist:
            return JsonResponse({'error': 'Archivo no encontrado'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método de solicitud no válido'}, status=405)



# Subseccion de creacion de carga y pagos
# Crear un pago
@csrf_exempt

def create_pago(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            required_fields = ['email', 'monto']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({'error': f'Missing required field: {field}'}, status=400)
            
            user = FirebaseUser.objects.get(email=data.get('email'))
            pago = Pagos(
                id_usuario=user,
                monto=data.get('monto'),
                estado='pendiente'
            )
            pago.save()
            return JsonResponse({'message': 'Pago creado con exito', 'pago_id': pago.id})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'Usuario no encontrado'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
        
# Exito de pago
@csrf_exempt

def pago_exitoso(request):
    try:
        data = json.loads(request.body)
        pago = Pagos.objects.get(id=data.get('id_pago'))
        pago.estado = 'exitoso'
        pago.save()
        return JsonResponse({'message': 'Pago exitoso'})
    except Pagos.DoesNotExist:
        return JsonResponse({'error': 'Pago no encontrado'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
        
# Seccion de cargas
@csrf_exempt

def create_carga(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            required_fields = ['email', 'descripcion', 'fecha_retiro', 'id_pago', 'localizacion']
            for field in required_fields:
                if not data.get(field):
                    return JsonResponse({'error': f'Missing required field: {field}'}, status=400)
            
            user = FirebaseUser.objects.get(email=data.get('email'))
            pago = Pagos.objects.get(id=data.get('id_pago'))
            carga = Carga(
                id_usuario=user,
                id_pago=pago,
                descripcion=data.get('descripcion'),
                estado='pendiente',
                localizacion=data.get('localizacion') # Ubicación de la carga (direccion o coordenadas)
            )
            carga.save()
            return JsonResponse({'message': 'Carga creada con exito', 'carga_id': carga.id})
        except FirebaseUser.DoesNotExist:
            return JsonResponse({'error': 'Usuario no encontrado'}, status=404)
        except Pagos.DoesNotExist:
            return JsonResponse({'error': 'Pago no encontrado'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
@csrf_exempt

def edit_carga(request):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            carga = Carga.objects.get(id=data.get('id'))
            carga.descripcion = data.get('descripcion', carga.descripcion)
            carga.id_pago = Pagos.objects.get(id=data.get('id_pago', carga.id_pago.id))
            carga.localizacion = data.get('localizacion', carga.localizacion)
            carga.save()
            return JsonResponse({'message': 'Carga actualizada con exito'})
        except Carga.DoesNotExist:
            return JsonResponse({'error': 'Carga no encontrada'}, status=404)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
@csrf_exempt

def mark_carga_retirada(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            carga_id = data.get('id_carga')
            carga = Carga.objects.get(id=carga_id, id_usuario=request.user)
            carga.estado = 'retired'
            carga.fecha_retiro = timezone.now()
            carga.save()
            return JsonResponse({'message': 'Carga marcada como retirada'}, status=200)
        except Carga.DoesNotExist:
            return JsonResponse({'error': 'Carga no encontrada'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método de solicitud no válido'}, status=405)

# Chequear tramites de un usuario con el rol de tramitador
@csrf_exempt
def check_tramites_user(request):
    try:
        user = request.user
        tramites = Tramite.objects.filter(usuario_destino=user, estado__in=['pending', 'approved'])
        tramites_details = [{
            'titulo': tramite.titulo,
            'descripcion': tramite.descripcion,
            'fecha_inicio': tramite.fecha_inicio,
            'carga_id': tramite.carga.id,
            'estado': tramite.estado
        } for tramite in tramites]
        return JsonResponse({'tramites': tramites_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt

def check_tramite(request):
    try:
        data = json.loads(request.body)
        tramite = Tramite.objects.get(id=data.get('id_tramite'))
        tramite_details = {
            'titulo': tramite.titulo,
            'descripcion': tramite.descripcion,
            'fecha_inicio': tramite.fecha_inicio,
            'carga_id': tramite.carga.id,
            'estado': tramite.estado
        }
        # Retrieve the required files for the tramite
        required_files = ArchivoRequeridoTramite.objects.filter(tramite=tramite, status__in=['not_sent', 'rejected'])
        required_files_details = [{
            'file_type': file.tipo_archivo.name,
            'status': file.status,
            'feedback': file.feedback
        } for file in required_files]

        tramite_details['required_files'] = required_files_details
        return JsonResponse({'tramite': tramite_details})
    except Tramite.DoesNotExist:
        return JsonResponse({'error': 'Tramite no encontrado'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt

def view_tramites_conductor(request):
    try:
        user = request.user
        cargas = Carga.objects.filter(id_usuario=user, estado='approved')
        tramites = Tramite.objects.filter(carga__in=cargas, estado='approved')
        tramites_details = [{
            'titulo': tramite.titulo,
            'descripcion': tramite.descripcion,
            'fecha_inicio': tramite.fecha_inicio,
            'carga_id': tramite.carga.id,
            'estado': tramite.estado,
            'fecha_termino': tramite.fecha_termino
        } for tramite in tramites]
        return JsonResponse({'tramites': tramites_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt

def check_cargas_pendientes(request):
    try:
        user = request.user
        cargas = Carga.objects.filter(id_usuario=user, estado__in=['pending', 'approved'])
        cargas_details = [{
            'descripcion': carga.descripcion,
            'estado': carga.estado,
            'fecha_retiro': carga.fecha_retiro,
            'localizacion': carga.localizacion
        } for carga in cargas]
        return JsonResponse({'cargas': cargas_details})

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt

def check_cargas_retiradas(request):
    try:
        user = request.user
        cargas = Carga.objects.filter(id_usuario=user, estado='retired')
        cargas_details = [{
            'descripcion': carga.descripcion,
            'estado': carga.estado,
            'fecha_retiro': carga.fecha_retiro,
            'localizacion': carga.localizacion
        } for carga in cargas]
        return JsonResponse({'cargas': cargas_details})

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

# La idea de las cargas es que cuando este pendiente o aprobada, aparezca en la vista de conductor, donde el puede ver la carga y retirarla. 
# Cuando se retira, no se mostrara en la lista y se mostrara en el historial de cargas retiradas    

# Funcion cuando se termina el tramite y se valida el retiro de la carga
@csrf_exempt
def tramite_exitoso(request):
    try:
        data = json.loads(request.body)
        tramite = Tramite.objects.get(id=data.get('id_tramite'))

        # Verificar si todos los archivos relacionados están aprobados
        archivos_pendientes = ArchivoRequeridoTramite.objects.filter(tramite=tramite, status__in=['not_sent', 'rejected'])
        if archivos_pendientes.exists():
            return JsonResponse({'error': 'No todos los archivos relacionados están aprobados'}, status=400)

        tramite.estado = 'approved'
        tramite.fecha_termino = data.get('fecha_termino')
        tramite.save()

        carga = tramite.carga
        carga.estado = 'approved'
        carga.save()

        return JsonResponse({'message': 'Tramite exitoso'})
    except Tramite.DoesNotExist:
        return JsonResponse({'error': 'Tramite no encontrado'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

# Boleta de pago, archivo de retiro, carnet, carnet de conductor
# Tramitador
# id, usuario que lo creo, destinatario de usuario, rut destinatario, codigo de carga, fecha de retiro, tipo de carga, archivos requeridos.
# Carga
#