from datetime import datetime
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from core.utils import role_visado_required, token_required
from users.models import FirebaseUser
from .models import Pagos
from cargas.models import Carga

# Create your views here.
@csrf_exempt
@role_visado_required
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

@csrf_exempt
@token_required
def pago_exitoso(request):
    try:
        data = json.loads(request.body)
        pago = Pagos.objects.get(id=data.get('id_pago'))
        pago.fecha_pago = datetime.now()
        pago.estado = 'exitoso'
        pago.save()
        return JsonResponse({'message': 'Pago exitoso'})
    except Pagos.DoesNotExist:
        return JsonResponse({'error': 'Pago no encontrado'}, status=404)
    except json.JSONDecodeError:
        return JsonResponse({'error': 'Invalid JSON format'}, status=400)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@token_required
def get_user_pagos(request):
    try:
        user = request.user
        pagos = Pagos.objects.filter(id_usuario=user)
        pagos_details = [{
            'id': pago.id,
            'monto': pago.monto,
            'fecha_creacion': pago.fecha_creacion,
            'estado': pago.estado,
            'carga_id': Carga.objects.filter(id_pago=pago.id).values_list('id', flat=True).first()
        } for pago in pagos]
        return JsonResponse({'pagos': pagos_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)

@csrf_exempt
@role_visado_required
def list_pagos(request):
    try:
        pagos = Pagos.objects.all()
        pagos_details = [{
            'id': pago.id,
            'usuario': pago.id_usuario.email,
            'monto': pago.monto,
            'fecha_creacion': pago.fecha_creacion,
            'estado': pago.estado
        } for pago in pagos]
        return JsonResponse({'pagos': pagos_details})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
