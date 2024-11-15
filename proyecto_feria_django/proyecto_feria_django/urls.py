"""
URL configuration for proyecto_feria_django project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from core import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('migrate_firebase_users/', views.migrate_firebase_users, name='migrate_firebase_users'),
    # Rutas de creación
    path('create_user/', views.create_user, name='create_user'),
    path('edit_user/', views.edit_user, name='edit_user'),
    path('disable_user/', views.disable_user, name='disable_user'),
    path('enable_user/', views.enable_user, name='enable_user'),
    # Rutas de listados
    path('list_firebase_users/', views.list_firebase_users, name='list_firebase_users'),
    path('list_users/', views.list_users, name='list_users'),
    path('list_files/', views.list_files, name='list_files'),
    path('list_tramites/', views.list_tramites, name='list_tramites'),
    path('list_pagos/', views.list_pagos, name='list_pagos'),
    path('list_cargas/', views.list_cargas, name='list_cargas'),
        # Mobile specific view
    path('list_notifications/', views.list_notifications, name='list_notifications'),
    # Rutas de login
    path('login_user/', views.login_user, name='login_user'),
    path('logout_user/', views.logout_user, name='logout_user'),
    path('check_or_create_user/', views.check_or_create_user, name='check_or_create_user'),
    # Rutas de consultas
    path('get_user_details/', views.get_user_details, name='get_user_details'),
    # Rutas de roles
    path('user_role/', views.user_role, name='user_role'),
    path('delete_user_role/', views.delete_user_role, name='delete_user_role'),
        # Mobile specific view
    path('list_roles/', views.list_roles, name='list_roles'),
    # Rutas de archivos
    path('approve_archivo/<int:archivo_id>/', views.approve_archivo, name='approve_archivo'),
    path('reject_archivo/<int:archivo_id>/', views.reject_archivo, name='reject_archivo'),
        # Mobile specific view
    path('upload_file/', views.upload_file, name='upload_file'),
    path('get_user_assigned_files/', views.get_user_assigned_files, name='get_user_assigned_files'),

    # Rutas de notificaciones
    path('create_notification/', views.create_notification, name='create_notification'),
    path('user_notifications/', views.user_notifications, name='user_notifications'),
    # Rutas de pagos
    path('create_pago/', views.create_pago, name='create_pago'),
    path('pago_exitoso/', views.pago_exitoso, name='pago_exitoso'),
    path('get_user_pagos/', views.get_user_pagos, name='get_user_pagos'),
    # Rutas de cargas
    path('create_carga/', views.create_carga, name='create_carga'),
    path('edit_carga/', views.edit_carga, name='edit_carga'),
        # Mobile specific view
    path('mark_carga_retirada/', views.mark_carga_retirada, name='mark_carga_retirada'),
    path('check_cargas_pendientes/', views.check_cargas_pendientes, name='check_cargas_pendientes'),
    path('check_cargas_retiradas/', views.check_cargas_retiradas, name='check_cargas_retiradas'),
    # Rutas de trámites
    path('create_tramite/', views.create_tramite, name='create_tramite'),
    path('check_tramite/', views.check_tramite, name='check_tramite'),
    path('check_tramite_files/', views.check_tramite_files, name='check_tramite_files'),
    path('tramite_exitoso/', views.tramite_exitoso, name='tramite_exitoso'),
        # Mobile specific view
    path('check_tramites_user/', views.check_tramites_user, name='check_tramites_user'),
    path('view_tramites_conductor/', views.view_tramites_conductor, name='view_tramites_conductor'),

    # Rutas OCR
    path('compare_file/', views.compare_file, name='compare_file'),

    # Rutas de prueba (comentadas)
    # path('create_test_user/', views.create_test_user, name='create_test_user'),
    # path('create_test_user_with_visado_role/', views.create_test_user_with_visado_role, name='create_test_user_with_visado_role'),
    # path('create_default_roles/', views.create_default_roles, name='create_default_roles'),
    # path('create_file_types/', views.create_file_types, name='create_file_types'),
    # path('create_tramite_types/', views.create_tramite_types, name='create_tramite_types'),
]
