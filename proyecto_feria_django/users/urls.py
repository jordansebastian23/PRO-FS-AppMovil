from django.urls import path
from users import views

urlpatterns = [
    path('check_or_create_user/', views.check_or_create_user, name='check_or_create_user'),
    path('edit_user/', views.edit_user, name='edit_user'),
    path('login_user/', views.login_user, name='login_user'),
    path('logout_user/', views.logout_user, name='logout_user'),
    path('get_user_details/', views.get_user_details, name='get_user_details'),
    # check if its being used
    path('user_role/', views.user_role, name='user_role'),
    path('delete_user_role/', views.delete_user_role, name='delete_user_role'),
    path('list_roles/', views.list_roles, name='list_roles'),
    path('list_users/', views.list_users, name='list_users'),
    path('disable_user/', views.disable_user, name='disable_user'),
    path('enable_user/', views.enable_user, name='enable_user'),

    # Testing purposes
    path('create_default_roles/', views.create_default_roles, name='create_default_roles'),
    path('create_test_user_with_visado_role/', views.create_test_user_with_visado_role, name='create_test_user_with_visado_role'),
]

