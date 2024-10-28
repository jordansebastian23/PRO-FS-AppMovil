"""
Django settings for proyecto_feria_django project.

Generated by 'django-admin startproject' using Django 5.1.2.

For more information on this file, see
https://docs.djangoproject.com/en/5.1/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/5.1/ref/settings/
"""

from pathlib import Path
import os
import dotenv 
import dj_database_url
import firebase_admin
from firebase_admin import credentials

dotenv.load_dotenv()

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.1/howto/deployment/checklist/


SECRET_KEY = os.getenv('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# Agregar los hosts permitidos
# Las ips que no sean locales deben ser quitadas en producción
ALLOWED_HOSTS = ['localhost', '127.0.0.1', '0.0.0.0', '10.32.110.72', '192.168.1.90', '192.168.246.4', '192.168.1.88']


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'core',
    'corsheaders',
    'storages',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'core.middleware.firebase_auth.FirebaseAuthMiddleware',
    # Cors middleware, para permitir peticiones desde cualquier origen
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
]

ROOT_URLCONF = 'proyecto_feria_django.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'proyecto_feria_django.wsgi.application'


# Database
# https://docs.djangoproject.com/en/5.1/ref/settings/#databases

# Base de datos postgresql
DATABASES = {
    'default': dj_database_url.config(default=os.getenv('DATABASE_URL'))
}


# Password validation
# https://docs.djangoproject.com/en/5.1/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/5.1/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

# Firebase
FIREBASE_SERVICE_ACCOUNT_KEY = BASE_DIR / 'serviceAccountKey.json'

cred = credentials.Certificate(FIREBASE_SERVICE_ACCOUNT_KEY)
firebase_admin.initialize_app(cred)

# Amazon Web Services S3 bucket
AWS_ACCESS_KEY_ID = os.getenv('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.getenv('AWS_SECRET_ACCESS_KEY')
AWS_STORAGE_BUCKET_NAME = os.getenv('AWS_STORAGE_BUCKET_NAME')
AWS_S3_REGION_NAME = os.getenv('AWS_S3_REGION_NAME')
AWS_S3_CUSTOM_DOMAIN = f'{AWS_STORAGE_BUCKET_NAME}.s3.amazonaws.com'

print(AWS_S3_CUSTOM_DOMAIN)

# For serving static files directly from S3
AWS_S3_URL_PROTOCOL = 'https'
AWS_S3_USE_SSL = True
AWS_S3_VERIFY = True

# Configuración de almacenamiento estático
STATICFILES_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'

# Configuración de almacenamiento de medios
DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'

# URL para archivos estáticos
STATIC_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/static/'

# URL para archivos de medios
MEDIA_URL = f'https://{AWS_S3_CUSTOM_DOMAIN}/media/'

# Directorio de archivos estáticos
STATICFILES_DIRS = [BASE_DIR / 'static']

# Directorio de archivos de medios
MEDIA_ROOT = BASE_DIR / 'media'

# Configuración de CORS
CORS_ALLOWED_ORIGINS = [
    # Agregar URL de aplicacion flutter
    "http://localhost:3000",
    "http://127.0.0.1:3000",
    "http://localhost:8000",
    "http://127.0.0.1:8000",
    "http://0.0.0.0:8000",
    "http://192.168.1.90:8000",
    "http://192.168.1.88:8000",
]

# Logging configuration for Django 
# LOGGING = {
#     'version': 1,
#     'disable_existing_loggers': False,
#     'handlers': {
#         'console': {
#             'level': 'DEBUG',
#             'class': 'logging.StreamHandler',
#         },
#         'file': {
#             'level': 'DEBUG',
#             'class': 'logging.FileHandler',
#             'filename': 'django.log',
#         },
#     },
#     'loggers': {
#         'django': {
#             'handlers': ['console', 'file'],
#             'level': 'DEBUG',
#             'propagate': True,
#         },
#         '': {
#             'handlers': ['console', 'file'],
#             'level': 'DEBUG',
#         },
#     },
# }


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/5.1/howto/static-files/

# Default primary key field type
# https://docs.djangoproject.com/en/5.1/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'