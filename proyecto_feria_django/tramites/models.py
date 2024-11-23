from django.db import models
from users.models import FirebaseUser
from cargas.models import Carga

# Create your models here.
# Modificar luego con los campos necesarios, como fecha de inicio, fecha de fin, nombre de archivos necesarios, etc.
class Tramite(models.Model):
    id = models.AutoField(primary_key=True)
    usuario_origen = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE, related_name='tramites_origen')
    usuario_destino = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE, related_name='tramites_destino')
    tramite_type = models.ForeignKey('TramiteType', on_delete=models.CASCADE)
    carga = models.ForeignKey(Carga, on_delete=models.CASCADE, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    estado = models.CharField(
        max_length=20,
        choices=[('pending', 'Pending'), ('approved', 'Approved')], #, ('rejected', 'Rejected') en caso de que se quiera agregar un estado de rechazo
        default='pending'
    )
    fecha_termino = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return self.titulo
    
class TramiteType(models.Model):
    name = models.CharField(max_length=100, unique=True)  # e.g., "FCL DIRECTO", "FCL INDIRECTO", "LCL DIRECTO", "LCL INDIRECTO"
    description = models.TextField(blank=True, null=True) # e.g., 'Contenedor de Carga Completa Directo", "Contenedor de Carga Completa Indirecto", "Carga Inferior a un Contenedor Directo", "Carga Inferior a un Contenedor Indirecto"

    def __str__(self):
        return self.name
