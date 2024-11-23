from datetime import timezone
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from core.utils import token_required, role_visado_required
from users.models import FirebaseUser
from pagos.models import Pagos
from .models import Carga
import json


@csrf_exempt
@role_visado_required
def create_carga(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            required_fields = ['email', 'descripcion', 'id_pago', 'localizacion']
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
            fecha_retiro = data.get('fecha_retiro')
            if fecha_retiro:
                carga.fecha_retiro = fecha_retiro
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
@role_visado_required
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
@role_visado_required
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

@csrf_exempt
@token_required
def check_cargas_pendientes(request):
    try:
        user = request.user
        cargas = Carga.objects.filter(id_usuario=user, estado__in=['pendiente', 'pending', 'approved'])
        cargas_details = [{
            'carga_id': carga.id,
            'descripcion': carga.descripcion,
            'estado': carga.estado,
            'fecha_retiro': carga.fecha_retiro,
            'localizacion': carga.localizacion
        } for carga in cargas]
        return JsonResponse({'cargas': cargas_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
    
@csrf_exempt
@token_required
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

@csrf_exempt
@role_visado_required
def list_cargas(request):
    try:
        cargas = Carga.objects.all()
        cargas_details = [{
            'id': carga.id,
            'usuario': carga.id_usuario.email,
            'descripcion': carga.descripcion,
            'fecha_creacion': carga.fecha_creacion,
            'fecha_retiro': carga.fecha_retiro,
            'localizacion': carga.localizacion,
            'estado': carga.estado
        } for carga in cargas]
        return JsonResponse({'cargas': cargas_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
