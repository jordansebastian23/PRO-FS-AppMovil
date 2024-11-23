# Required token decorator
from functools import wraps
from django.http import JsonResponse
from users.models import FirebaseUser, Roles


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

def role_visado_required(view_func):
    @wraps(view_func)
    def _wrapped_view(request, *args, **kwargs):
        token = request.headers.get('X-Auth-Token')
        if not token:
            return JsonResponse({"error": "Authorization token missing"}, status=401)

        try:
            user = FirebaseUser.objects.get(token=token)
            #if user.roles.filter(nombre='Visado').exists():
            if Roles.objects.filter(id_usuarios=user, nombre='Visado').exists():
                return view_func(request, *args, **kwargs)
            else:
                return JsonResponse({"error": "User does not have the required role"}, status=403)
        except FirebaseUser.DoesNotExist:
            return JsonResponse({"error": "Invalid token"}, status=401)
        
    return _wrapped_view