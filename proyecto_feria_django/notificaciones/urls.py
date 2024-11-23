from django.urls import path
from notificaciones import views

urlpatterns = [
    path('create_notification/', views.create_notification, name='create_notification'),
    path('user_notifications/', views.user_notifications, name='user_notifications'),
    path('check_notificacion/<int:notificacion_id>/', views.check_notificacion, name='check_notificacion'),
]