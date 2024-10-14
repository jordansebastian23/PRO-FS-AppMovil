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
    
