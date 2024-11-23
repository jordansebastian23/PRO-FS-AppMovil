import os
import boto3
from django.db import IntegrityError
from django.forms import ValidationError
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse

from core.utils import role_visado_required, token_required
from files.models import Archivo,TramiteFileRequirement as ArchivoRequeridoTramite, FileType as TipoArchivo
from tramites.models import Tramite

from firebase_admin import auth

import json

# Configurar el cliente de S3
s3_client = boto3.client(
    's3',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
    region_name=os.getenv('AWS_S3_REGION_NAME')
)

@csrf_exempt
@token_required
def upload_file(request):
    if request.method == 'POST' and request.FILES.get('file'):
        user = request.user
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
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request'}, status=400)

@csrf_exempt
@role_visado_required
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
@role_visado_required
def reject_archivo(request, archivo_id):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            archivo = ArchivoRequeridoTramite.objects.get(id=archivo_id)
            archivo.status = 'rejected'
            archivo.feedback = data.get('feedback', '')
            archivo.save()
            return JsonResponse({'message': 'Archivo rechazado exitosamente'}, status=200)
        except ArchivoRequeridoTramite.DoesNotExist:
            return JsonResponse({'error': 'Archivo no encontrado'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Método de solicitud no válido'}, status=405)

@csrf_exempt
@token_required
def get_user_assigned_files(request):
    try:
        user = request.user
        # Obtener los trámites asignados al usuario
        tramites = Tramite.objects.filter(usuario_destino=user)
        # Obtener los archivos requeridos para estos trámites que no han sido enviados o han sido rechazados
        archivos_requeridos = ArchivoRequeridoTramite.objects.filter(
            tramite__in=tramites,
            status__in=['not_sent', 'rejected']
        )
        archivos_details = [{
            'id': archivo.id,
            'tramite_id': archivo.tramite.id,
            'tramite_tipo': archivo.tramite.tramite_type.name,
            'tipo_archivo': archivo.tipo_archivo.name,
            'tipo_archivo_id': archivo.tipo_archivo.id,
            'status': archivo.status,
            'feedback': archivo.feedback
        } for archivo in archivos_requeridos]
        return JsonResponse({'archivos': archivos_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@role_visado_required
def list_files(request):
    try:
        files = Archivo.objects.all()
        files_details = [{
            'id': file.id,
            'usuario': file.usuario.email,
            'nombre_archivo': file.nombre_archivo,
            'tipo_archivo': file.tipo_archivo,
            's3_url': file.s3_url,
            'fecha_subida': file.fecha_subida,
            'estado_procesamiento': file.estado_procesamiento
        } for file in files]
        return JsonResponse({'files': files_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
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

# Crear tipos de archivos predeterminados
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