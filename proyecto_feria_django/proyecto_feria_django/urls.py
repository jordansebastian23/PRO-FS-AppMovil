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
    path('upload_file/', views.upload_file, name='upload_file'),
    # Rutas de creacion
    path('create_test_tramite/', views.create_test_tramite, name='create_test_tramite'),
    path('create_test_user/', views.create_test_user, name='create_test_user'),
    path('create_user/', views.create_user, name='create_user'),
    # Rutas de listados
    path('list_firebase_users/', views.list_firebase_users, name='list_firebase_users'),
    path('list_users/', views.list_users, name='list_users'),
    path('list_files/', views.list_files, name='list_files'),
    path('list_tramites/', views.list_tramites, name='list_tramites'),
    # Rutas de login
    path('login_user/', views.login_user, name='login_user'),
    path('logout_user/', views.logout_user, name='logout_user'),
    # Rutas de eliminacion
    path('delete_user/', views.delete_user, name='delete_user'),
    # Rutas de consultas
    path('get_user_details/', views.get_user_details, name='get_user_details'),
]
