from django.db import models
from users.models import FirebaseUser
from pagos.models import Pagos

# Create your models here.
    
class Carga(models.Model):
    id = models.AutoField(primary_key=True)
    id_usuario = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE) # Usuario que realiza la carga
    id_pago = models.ForeignKey(Pagos, on_delete=models.CASCADE, null=True, blank=True) # Pago asociado a la carga, puede crearse la carga sin pago y luego asignarle un pago
    descripcion = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_retiro = models.DateTimeField(null=True, blank=True)
    localizacion = models.CharField(max_length=100, null=True, blank=True) # Ubicación de la carga (direccion o coordenadas)
    estado = models.CharField(
        max_length=20,
        choices=[('pending', 'Pending'), ('approved', 'Approved'), ('retired', 'Retired')],
        default='pending'
    )

    def __str__(self):
        return self.id_usuario.email

