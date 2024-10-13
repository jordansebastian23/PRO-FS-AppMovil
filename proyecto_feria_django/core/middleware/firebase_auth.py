import firebase_admin
from firebase_admin import auth
from django.conf import settings
from django.http import JsonResponse

class FirebaseAuthMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        id_token = request.META.get('HTTP_AUTHORIZATION')
        if id_token:
            try:
                decoded_token = auth.verify_id_token(id_token)
                request.user = decoded_token
            except Exception as e:
                return JsonResponse({'error': str(e)}, status=401)
        return self.get_response(request)