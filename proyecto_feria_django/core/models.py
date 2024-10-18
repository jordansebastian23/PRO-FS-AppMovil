from django.db import models

# Modelo de usuario de Firebase
class FirebaseUser(models.Model):
    uid = models.CharField(max_length=100, primary_key=True)
    email = models.EmailField()
    display_name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=20, null=True, blank=True)
    photo_url = models.URLField(null=True, blank=True)
    disabled = models.BooleanField(default=False)
    
    def __str__(self):
        return self.email
    
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
    
class Tramite(models.Model):
    id = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE)
    titulo = models.CharField(max_length=100)
    descripcion = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    id_archivos = models.ManyToManyField(Archivo)
    estado = models.CharField(max_length=50, default='pendiente')

    def __str__(self):
        return self.titulo
    
class Roles(models.Model):
    id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    descripcion = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    id_usuarios = models.ManyToManyField(FirebaseUser)

    def __str__(self):
        return self.nombre
    
class Notificaciones(models.Model):
    id = models.AutoField(primary_key=True)
    id_origen = models.ForeignKey(FirebaseUser, on_delete=models.CASCADE, related_name='notificaciones_origen')
    id_destino = models.ManyToManyField(FirebaseUser, related_name='notificaciones_destino')
    mensaje = models.TextField()
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    titulo = models.CharField(max_length=255)

    def __str__(self):
        return self.titulo