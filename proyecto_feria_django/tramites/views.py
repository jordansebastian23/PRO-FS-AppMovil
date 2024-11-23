from datetime import timezone
import json
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from tramites.models import Tramite, TramiteType
from cargas.models import Carga
from users.models import FirebaseUser
from files.models import FileType as TipoArchivo, TramiteFileRequirement as ArchivoRequeridoTramite
from core.utils import token_required, role_visado_required

@csrf_exempt
@role_visado_required
def list_tramites(request):
    try:
        tramites = Tramite.objects.all()
        tramites_details = [{
            'id': tramite.id,
            'tipo_tramite': tramite.tramite_type.name,
            'usuario_origen': tramite.usuario_origen.display_name,
            'usuario_destino': tramite.usuario_destino.display_name,
            'carga_id': tramite.carga.id if tramite.carga else None,
            'fecha_creacion': tramite.fecha_creacion,
            'estado': tramite.estado,
            'fecha_termino': tramite.fecha_termino
        } for tramite in tramites]
        return JsonResponse({'tramites': tramites_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt
@role_visado_required
def create_tramite(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        required_fields = ['tipo_tramite', 'usuario_destino', 'carga_id', 'file_type_ids']
        
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

            tipo_tramite = TramiteType.objects.get(name=data['tipo_tramite'])

            # Create the Tramite object
            tramite = Tramite.objects.create(
                usuario_origen=usuario_origen,
                usuario_destino=usuario_destino,
                tramite_type=tipo_tramite,
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

@csrf_exempt
@token_required
def check_tramites_user(request):
    try:
        user = request.user
        tramites = Tramite.objects.filter(usuario_destino=user, estado__in=['pending', 'approved'])
        tramites_details = [{
            'tipo_tramite': tramite.tramite_type.name,
            'fecha_inicio': tramite.fecha_creacion,
            'fecha_termino': tramite.fecha_termino,
            'carga_id': tramite.carga.id,
            'estado': tramite.estado
        } for tramite in tramites]
        return JsonResponse({'tramites': tramites_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt
# TODO: Revisar si se necesita el decorador role_visado_required
@token_required
def check_tramite(request):
    try:
        data = json.loads(request.body)
        tramite = Tramite.objects.get(id=data.get('id_tramite'))
        tramite_details = {
            'tramite_type': tramite.tramite_type.name,
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
@role_visado_required
def check_tramite_files(request):
    try:
        data = json.loads(request.body)
        tramite = Tramite.objects.get(id=data.get('id_tramite'))
        required_files = ArchivoRequeridoTramite.objects.filter(tramite=tramite)
        required_files_details = [{
            'file_type': file.tipo_archivo.name,
            'status': file.status,
            'feedback': file.feedback,
            'file_url': file.archivo.s3_url if file.archivo else None,
            'file_id': file.id
        } for file in required_files]
        return JsonResponse({'required_files': required_files_details})
    except Tramite.DoesNotExist:
        return JsonResponse({'error': 'Tramite not found'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@token_required
def view_tramites_conductor(request):
    try:
        user = request.user
        cargas = Carga.objects.filter(id_usuario=user, estado__in=['pendiente', 'pending', 'approved'])
        tramites = Tramite.objects.filter(carga__in=cargas, estado__in=['pendiente', 'pending', 'approved'])
        tramites_details = [{
            'tramite_type': tramite.tramite_type.name,
            'fecha_creacion': tramite.fecha_creacion,
            'carga_id': tramite.carga.id,
            'estado': tramite.estado,
            'fecha_termino': tramite.fecha_termino
        } for tramite in tramites]
        return JsonResponse({'tramites': tramites_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

# Funcion cuando se termina el tramite y se valida el retiro de la carga
@csrf_exempt
@role_visado_required
def tramite_exitoso(request):
    try:
        data = json.loads(request.body)
        tramite = Tramite.objects.get(id=data.get('id_tramite'))

        # Verificar si todos los archivos relacionados están aprobados
        archivos_pendientes = ArchivoRequeridoTramite.objects.filter(tramite=tramite, status__in=['not_sent', 'rejected'])
        if archivos_pendientes.exists():
            return JsonResponse({'error': 'No todos los archivos relacionados están aprobados'}, status=400)

        tramite.estado = 'approved'
        tramite.fecha_termino = timezone.now()
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
    
DEFAULT_TIPOS_TRAMITES = [
    "FCL DIRECTO",
    "FCL INDIRECTO",
    "LCL DIRECTO",
    "LCL INDIRECTO"
]

DESCRIPCIONES_TIPOS_TRAMITES = [
    "Tramite para contenedor de carga completa FCL directa",
    "Tramite para contenedor de carga completa FCL indirecta",
    "Tramite para carga inferior a un contenedor LCL directa",
    "Tramite para carga inferior a un contenedor LCL directa"
]

@csrf_exempt
def create_tramite_types(request):
    if request.method == 'POST':
        for tipo, descripcion in zip(DEFAULT_TIPOS_TRAMITES, DESCRIPCIONES_TIPOS_TRAMITES):
            try:
                TramiteType.objects.get_or_create(
                    name=tipo,
                    defaults={'description': descripcion}
                )
            except Exception as e:
                return JsonResponse({'error': str(e)}, status=500)
        return JsonResponse({'message': 'Default tramite types created successfully'})