from django.urls import path
from cargas import views

urlpatterns = [
    path('create_carga/', views.create_carga, name='create_carga'),
    path('edit_carga/', views.edit_carga, name='edit_carga'),
    path('mark_carga_retirada/', views.mark_carga_retirada, name='mark_carga_retirada'),
    path('check_cargas_pendientes/', views.check_cargas_pendientes, name='check_cargas_pendientes'),
    path('check_cargas_retiradas/', views.check_cargas_retiradas, name='check_cargas_retiradas'),
    path('list_cargas/', views.list_cargas, name='list_cargas'),
]