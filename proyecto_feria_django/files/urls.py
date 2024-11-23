from django.urls import path

from files import views

urlpatterns = [
    path('upload_file/', views.upload_file, name='upload_file'),
    path('list_files/', views.list_files, name='list_files'),
    path('approve_archivo/<int:archivo_id>/', views.approve_archivo, name='approve_archivo'),
    path('reject_archivo/<int:archivo_id>/', views.reject_archivo, name='reject_archivo'),
    path('get_user_assigned_files/', views.get_user_assigned_files, name='get_user_assigned_files'),
    # path('create_file_types/', views.create_file_types, name='create_file_types'),
]
