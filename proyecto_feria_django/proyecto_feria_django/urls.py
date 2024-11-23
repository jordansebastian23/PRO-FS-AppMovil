from django.contrib import admin
from django.urls import path, include
from core import views
from ml import views as ml_views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('files/', include('files.urls')),
    path('users/', include('users.urls')),
    path('cargas/', include('cargas.urls')),
    path('tramites/', include('tramites.urls')),
    path('notificaciones/', include('notificaciones.urls')),
    path('pagos/', include('pagos.urls')),
    #path('migrate_firebase_users/', views.migrate_firebase_users, name='migrate_firebase_users'),
    # Rutas de listados
    #path('list_firebase_users/', views.list_firebase_users, name='list_firebase_users'),
        # Mobile specific view
    #path('list_notifications/', views.list_notifications, name='list_notifications'),
    # Rutas OCR
    path('ml/compare_file/', ml_views.compare_file, name='compare_file'),
    # Rutas de prueba (comentadas)
    # path('create_test_user/', views.create_test_user, name='create_test_user'),
    # path('create_test_user_with_visado_role/', views.create_test_user_with_visado_role, name='create_test_user_with_visado_role'),
    # path('create_default_roles/', views.create_default_roles, name='create_default_roles'),
    # path('create_file_types/', views.create_file_types, name='create_file_types'),
    # path('create_tramite_types/', views.create_tramite_types, name='create_tramite_types'),
]
