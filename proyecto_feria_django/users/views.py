from django.db import IntegrityError
from django.forms import ValidationError
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

from core.utils import role_visado_required, token_required
from users.models import FirebaseUser, Roles

from firebase_admin import auth

import secrets
import json

# Create your views here.
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

# Obtener o crear un token para un usuario de google, aunque puede ser utilizado para cualquier usuario
@csrf_exempt
def check_or_create_user(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            uid = data.get('uid')
            email = data.get('email')
            display_name = data.get('display_name')
            photo_url = data.get('photo_url')
            password = data.get('password')
            phone_number = data.get('phone_number')

            if not email:
                return JsonResponse({'error': 'Email is required'}, status=400)

            # Combine the name fields if available (for the web admin version)
            if 'apellido_materno' in data and 'apellido_paterno' in data:
                display_name = f"{display_name} {data.get('apellido_paterno', '')} {data.get('apellido_materno', '')}"

            # Determine if the user is a local user or a Google user
            is_local_user = not uid

            if is_local_user:
                # Validate required fields for local users
                required_fields = ['display_name', 'phone_number', 'password']
                for field in required_fields:
                    if not data.get(field):
                        return JsonResponse({'error': f'Missing required field: {field}'}, status=400)

                # Create the user
                user, created = FirebaseUser.objects.get_or_create(
                    email=email,
                    defaults={
                        'uid': None,
                        'display_name': display_name,
                        'phone_number': phone_number,
                        'photo_url': None,  # Placeholder, can add profile image handling later
                        'disabled': False,
                        'is_local_user': True,
                        'password': password  # Password will be hashed in the model
                    }
                )
            else:
                # Create or get the Google user
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

            # Check if the user already has a role
            if not user.roles_set.exists():
                # Assign the role to the user, defaulting to 'Tramites'
                role_name = data.get('role', 'Tramites')
                role = Roles.objects.get(nombre=role_name)
                role.id_usuarios.add(user)

            return JsonResponse({'token': user.token if not is_local_user else None, 'message': 'User created or updated successfully', 'user': user.email})

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
@role_visado_required
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
@role_visado_required
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
@role_visado_required
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
            'disabled': user.disabled,
            "roles": [role.nombre for role in user.roles_set.all()]
        }
        return JsonResponse(user_data)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)

@role_visado_required
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


# Check if this is being called from a POST request, since i think its not being used
@csrf_exempt
@role_visado_required
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
@role_visado_required
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
    
# Lista de usuarios en general
@role_visado_required
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
@csrf_exempt
def create_default_roles(request):
    if request.method == 'POST':
        for nombre, descripcion in zip(DEFAULT_ROLES, DESCRIPCIONES):
            try:
                Roles.objects.get_or_create(
                    nombre=nombre,
                    defaults={'descripcion': descripcion}
                )
            except Exception as e:
                return JsonResponse({'error': str(e)}, status=500)
        return JsonResponse({'message': 'Default roles created successfully'})

@csrf_exempt
def create_test_user_with_visado_role(request):
    if request.method == 'POST':
        try:
            # Create a local user
            local_user = FirebaseUser.objects.create(
                uid=None,
                email="testvisado@example.com",
                display_name="Test Visado User",
                phone_number="1234567890",
                photo_url=None,
                disabled=False,
                is_local_user=True,
                password="password123"
            )

            # Assign the "Visado" role to the user
            visado_role = Roles.objects.get(nombre="Visado")
            visado_role.id_usuarios.add(local_user)

            return JsonResponse({'message': 'Test user with Visado role created successfully', 'user': local_user.email})
        except Roles.DoesNotExist:
            return JsonResponse({'error': 'Visado role not found'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
