from django.db import models
from django.contrib.auth.hashers import make_password, check_password
from django.contrib.auth.models import AbstractBaseUser

# Modelo de usuario de Firebase
class FirebaseUser(AbstractBaseUser):
    uid = models.CharField(max_length=100, null=True, blank=True)  # UID de Google, opcional para usuarios locales
    email = models.EmailField(unique=True)  # El email debe ser único para ambos tipos de usuarios
    display_name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=20, null=True, blank=True)
    photo_url = models.URLField(null=True, blank=True)
    disabled = models.BooleanField(default=False)
    is_local_user = models.BooleanField(default=False)  # Indica si el usuario es local o de Google
    password = models.CharField(max_length=128, null=True, blank=True)  # Contraseña para usuarios locales
    token = models.CharField(max_length=32, null=True, blank=True) # Token para usuarios locales

    
    # Required fields for session management
    last_login = models.DateTimeField(auto_now=True)
    is_active = models.BooleanField(default=True)


    USERNAME_FIELD = 'email'

    def save(self, *args, **kwargs):
        if self.is_local_user and self.password and not self.password.startswith('pbkdf2_sha256$'):
            self.password = make_password(self.password)
        super(FirebaseUser, self).save(*args, **kwargs)

    def check_password(self, password):
        return check_password(password, self.password)

    def __str__(self):
        return self.email

    def is_authenticated(self):
        return True  # Required for Django's session-based login

    class Meta:
        verbose_name = 'Firebase User'


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