import json
from django.shortcuts import render
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from core.utils import token_required, role_visado_required
from users.models import FirebaseUser
from .models import Notificaciones

# Create your views here.
@csrf_exempt
@role_visado_required
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
                id_origen=user_origen,
                estado='not_seen'
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

@csrf_exempt
@token_required
def user_notifications(request):
    if request.method == 'GET':
        try:
            user = request.user
            notificaciones = Notificaciones.objects.filter(id_destino=user, estado='not_seen')
            notificaciones_data = [{
                'id': notificacion.id,
                'titulo': notificacion.titulo,
                'mensaje': notificacion.mensaje,
                'id_origen': notificacion.id_origen.email,
                'fecha_creacion': notificacion.fecha_creacion,
                'estado': notificacion.estado
            } for notificacion in notificaciones]
            return JsonResponse({'notificaciones': notificaciones_data})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
@token_required
def check_notificacion(request, notificacion_id):
    if request.method == 'PUT':
        try:
            user = request.user
            notificacion = Notificaciones.objects.get(id=notificacion_id, id_destino=user)
            notificacion.estado = 'seen'
            notificacion.save()
            return JsonResponse({'message': 'Notification marked as seen'})
        except Notificaciones.DoesNotExist:
            return JsonResponse({'error': 'Notification not found'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=405)