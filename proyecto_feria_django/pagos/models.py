from django.db import models
from users.models import FirebaseUser

# Create your models here.
class Pagos(models.Model):
    id = models.AutoField(primary_key=True)
    id_usuario = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE) # Usuario que realiza el pago
    monto = models.FloatField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_pago = models.DateTimeField(null=True, blank=True)
    estado = models.CharField(
        max_length=20,
        choices=[('pending', 'Pending'), ('approved', 'Approved')],
        default='pending'
    )

    def __str__(self):
        return self.id_usuario.email
