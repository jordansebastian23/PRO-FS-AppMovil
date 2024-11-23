from django.db import models
from users.models import FirebaseUser
from tramites.models import Tramite

# Create your models here.
class Archivo(models.Model):
    id = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE)
    nombre_archivo = models.CharField(max_length=100)
    tipo_archivo = models.CharField(max_length=100)
    s3_url = models.URLField()
    fecha_subida = models.DateTimeField(auto_now_add=True)
    estado_procesamiento = models.CharField(max_length=50, default='pendiente')

    def __str__(self):
        return self.nombre_archivo
    
class FileType(models.Model):
    name = models.CharField(max_length=100, unique=True)  # e.g., "Carnet", "Boleta de pago"
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return self.name
    
    
class TramiteFileRequirement(models.Model):
    id = models.AutoField(primary_key=True)
    tipo_archivo = models.ForeignKey(FileType, on_delete=models.CASCADE, null=True, blank=True)
    tramite = models.ForeignKey(Tramite, on_delete=models.CASCADE, related_name='tramite_file_requirements')
    archivo = models.ForeignKey(Archivo, on_delete=models.SET_NULL, null=True, blank=True)
    status = models.CharField(
        max_length=20,
        choices=[('not_sent', 'Not Sent'), ('pending', 'Pending'), ('approved', 'Approved'), ('rejected', 'Rejected')],
        default='pending'
    )
    feedback = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.tramite.titulo} - {self.tipo_archivo.name}"