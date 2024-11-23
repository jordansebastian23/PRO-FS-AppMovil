from django.urls import path
from pagos import views

urlpatterns = [
    path('create_pago/', views.create_pago, name='create_pago'),
    path('pago_exitoso/', views.pago_exitoso, name='pago_exitoso'),
    path('get_user_pagos/', views.get_user_pagos, name='get_user_pagos'),
    path('list_pagos/', views.list_pagos, name='list_pagos'),
]