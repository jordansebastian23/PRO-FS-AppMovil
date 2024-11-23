from django.db import models
from users.models import FirebaseUser

# Create your models here.
class Notificaciones(models.Model):
    id = models.AutoField(primary_key=True)
    id_origen = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE, related_name='notificaciones_origen')
    id_destino = models.ManyToManyField(FirebaseUser, related_name='notificaciones_destino')
    mensaje = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    titulo = models.CharField(max_length=255)
    estado = models.CharField(
        max_length=20,
        choices=[('not_seen', 'Not Seen'), ('seen', 'Seen')],
        default='pending'
        )

    def __str__(self):
        return self.titulo
    
