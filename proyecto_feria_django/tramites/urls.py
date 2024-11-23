from django.urls import path
from tramites import views

urlpatterns = [
    path('list_tramites/', views.list_tramites, name='list_tramites'),
    path('create_tramite/', views.create_tramite, name='create_tramite'),
    path('check_tramite/', views.check_tramite, name='check_tramite'),
    path('check_tramite_files/', views.check_tramite_files, name='check_tramite_files'),
    path('tramite_exitoso/', views.tramite_exitoso, name='tramite_exitoso'),
    path('check_tramites_user/', views.check_tramites_user, name='check_tramites_user'),
    path('view_tramites_conductor/', views.view_tramites_conductor, name='view_tramites_conductor'),

    # Testing purposes
    path('create_tramite_types/', views.create_tramite_types, name='create_tramite_types'),
    
]