from difflib import SequenceMatcher
import json
import logging
import re
import boto3
import os
import cv2
from django.db import IntegrityError
from django.forms import ValidationError
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import logout, login
from django.contrib.auth.hashers import check_password
import firebase_admin
from firebase_admin import auth
from pdf2image import convert_from_path
import pytesseract
from PIL import Image
import requests


from functools import wraps

# Tesseract and OCR views
# pytesseract.pytesseract.tesseract_cmd = "C:/Program Files/Tesseract-OCR/tesseract.exe"
# poppler_path = r'C:\Users\vicen\Documents\poppler-24.08.0\Library\bin'

# This is for linux
# pytesseract.pytesseract.tesseract_cmd = "/usr/bin/tesseract"
# poppler_path = "/usr/bin"

# def preprocess_image(image_path):
#     img = cv2.imread(image_path, cv2.IMREAD_COLOR)
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#     _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY_INV)
#     denoised = cv2.fastNlMeansDenoising(thresh, None, 30, 7, 21)
#     return denoised

# def extract_text_with_ocr(image_path):
#     # Preprocess the image
#     preprocessed_image = preprocess_image(image_path)
#     # Convert the numpy array to a PIL Image
#     pil_image = Image.fromarray(preprocessed_image)
#     # Perform OCR on the PIL Image
#     return pytesseract.image_to_string(pil_image)

# def convert_pdf_to_jpg(pdf_path):
#     # No need to specify poppler_path explicitly on Linux Docker if it's installed in the default location
#     images = convert_from_path(pdf_path)  
#     image_path = pdf_path.replace('.pdf', '.jpg')
#     images[0].save(image_path, 'JPEG')
#     return image_path

# def extract_boleta_data(text):
#     data = {}
#     # Extract "Total" amount
#     total_match = re.search(r"Total:\s*([\d.,]+)", text)
#     data["Total"] = total_match.group(1) if total_match else None
#     # Extract "Domicilio" address
#     domicilio_match = re.search(r"Domicilio:\s*([^\n]+)", text)
#     data["Domicilio"] = domicilio_match.group(1) if domicilio_match else None
#     # Extract "Rut" value
#     rut_match = re.search(r"RUT:\s*([\d.-]+)", text)
#     data["Rut"] = rut_match.group(1) if rut_match else None

#     # Extract "N °" number
#     numero_match = re.search(r"N °\s*(\d+)", text)
#     data["Numero"] = numero_match.group(1) if numero_match else None
#     # Extract "Fecha"
#     fecha_match = re.search(r"Fecha:\s*([^\n]+)", text)
#     data["Fecha"] = fecha_match.group(1) if fecha_match else None
#     return data

# def extract_carnet_data(text):
#     data = {}
#     # Extract "RUN" using a flexible format (e.g., "RUN 12.749.625-K")
#     run_match = re.search(r"RUN\s+([\d.]+-[\dkK])", text, re.IGNORECASE)
#     data["RUN"] = run_match.group(1) if run_match else None
#     # Extract full name - Assuming names appear on two separate lines with potential first and last names
#     # Example: Name pattern "FirstName MiddleName LastName"
#     name_match = re.findall(r"[A-Z]{2,}\s+[A-Z]{2,}", text)
#     data["Full Name"] = " ".join(name_match[:2]) if name_match else None
#     # Extract date of birth or issue date (look for patterns like "21 FEB 1982")
#     dob_match = re.search(r"\b(\d{1,2}\s+[A-Z]{3}\s+\d{4})\b", text)
#     data["Date of Birth"] = dob_match.group(1) if dob_match else None
#     # Extract expiry or issue dates (look for two dates - issued and expiry dates)
#     dates_match = re.findall(r"\b(\d{1,2}\s+[A-Z]{3}\s+\d{4})\b", text)
#     if len(dates_match) >= 2:
#         data["Issue Date"], data["Expiry Date"] = dates_match[0], dates_match[1]
#     else:
#         data["Issue Date"], data["Expiry Date"] = (None, None)
#     return data

# def is_similar(text1, text2, threshold=0.9):
#     """Return True if the similarity ratio of two strings is above the threshold."""
#     return SequenceMatcher(None, text1, text2).ratio() > threshold

# # Cambiar nombre de la vista
# def my_view(request):
#     if request.user:
#         return JsonResponse({'message': 'Authenticated', 'user': request.user})
#     else:
#         return JsonResponse({'message': 'Not authenticated'}, status=401)

# @csrf_exempt
# @token_required
# def compare_file(request):
#     if request.method == 'POST':
#         data = json.loads(request.body)
#         file_url = data.get('file_url')
#         template_type = data.get('template_type')
#         if not file_url or not template_type:
#             return JsonResponse({"error": "File URL or template type missing"}, status=400)

#         # Download the file from the S3 URL
#         file_path = f"/tmp/{file_url.split('/')[-1]}"
#         try:
#             response = requests.get(file_url)
#             response.raise_for_status()  # Raise an error for HTTP issues
#             with open(file_path, 'wb') as f:
#                 f.write(response.content)
            
#             # Check if file was downloaded successfully
#             if not os.path.exists(file_path) or os.path.getsize(file_path) == 0:
#                 return JsonResponse({"error": "Failed to download file or file is empty"}, status=500)
#         except Exception as e:
#             return JsonResponse({"error": f"Failed to download file: {e}"}, status=500)

#         # Define S3 file paths for comparison
#         bucket_name = os.getenv('AWS_STORAGE_BUCKET_NAME')
#         if template_type == "carnet":
#             comparison_key = "carnet.jpg"
#         elif template_type == "boleta":
#             comparison_key = "boleta_sample.pdf"
#         else:
#             return JsonResponse({"error": "Unknown template type"}, status=400)

#         # Download the comparison file from S3
#         comparison_path = f"/tmp/{comparison_key}"
#         s3_client.download_file(bucket_name, comparison_key, comparison_path)

#         # Convert PDF to image if needed
#         if comparison_path.endswith('.pdf'):
#             comparison_path = convert_pdf_to_jpg(comparison_path)

#         if file_path.endswith('.pdf'):
#             file_path = convert_pdf_to_jpg(file_path)

#         # Perform OCR
#         print("Performing OCR on" + file_path + " and " + comparison_path) 
#         user_text = extract_text_with_ocr(file_path)
#         print("Texto de usuario: \n " + user_text)
#         comparison_text = extract_text_with_ocr(comparison_path)
#         print("Texto de comparacion: \n" + comparison_text)

#         # Simple comparison logic (customize as needed)
#         result = {}
#         if template_type == "carnet":
#             user_data = extract_carnet_data(user_text)
#             comparison_data = extract_carnet_data(comparison_text)

#             # Compare fields
#             comparison_result = {
#                 "RUN": user_data["RUN"] == comparison_data["RUN"],
#                 "Name": is_similar(user_data["Full Name"], comparison_data["Full Name"]),
#                 "Issue_Date": user_data["Issue Date"] == comparison_data["Issue Date"],
#                 "Expiry_Date": user_data["Expiry Date"] == comparison_data["Expiry Date"]
#             }
#         elif template_type == "boleta":
#             user_data = extract_boleta_data(user_text)
#             comparison_data = extract_boleta_data(comparison_text)

#             # Compare extracted fields
#             comparison_result = {
#                 "Total": user_data["Total"] == comparison_data["Total"],
#                 "Domicilio": user_data["Domicilio"] == comparison_data["Domicilio"],
#                 "Rut": user_data["Rut"] == comparison_data["Rut"],
#                 "Numero": user_data["Numero"] == comparison_data["Numero"],
#                 "Fecha": user_data["Fecha"] == comparison_data["Fecha"]
#             }

#         # Clean up temp files
#         os.remove(file_path)
#         os.remove(comparison_path)

#         return JsonResponse({"comparison_result": comparison_result, "user_data": user_data, "comparison_data": comparison_data}, status=200)

#     return JsonResponse({"error": "Invalid request method"}, status=405)

# @csrf_exempt
# def list_notifications(request):
#     try:
#         notifications = Notificaciones.objects.all()
#         notifications_details = [{
#             'id': notification.id,
#             'titulo': notification.titulo,
#             'mensaje': notification.mensaje,
#             'origen': notification.id_origen.email,
#             'destinos': [user.email for user in notification.id_destino.all()],
#             'fecha_creacion': notification.fecha_creacion
#         } for notification in notifications]
#         return JsonResponse({'notifications': notifications_details})
#     except Exception as e:
#         return JsonResponse({'error': str(e)}, status=500)
    


# def create_test_user(request):
#     # Crear un usuario local sin un uid
#     try:
#         local_user = FirebaseUser.objects.create(
#             uid=None,  # This can be left as None or omitted entirely
#             email="localuser@example.com",
#             display_name="Local User",
#             phone_number="1234567890",
#             photo_url=None,
#             disabled=False,
#             is_local_user=True,  # Mark as a local user
#             password="password123"  # Password will be hashed in the model
#         )
#         return JsonResponse({'message': 'User created successfully', 'user': [local_user.email]})
#     except Exception as e:
#         return JsonResponse({'error': str(e)}, status=500)
    

# Seccion de roles

DEFAULT_ROLES = [
    "Tramites",
    "Conductor",
    "Visado"
]
DESCRIPCIONES = [
    "Rol para la persona que viene a realizar tramites para el retiro de la carga",
    "Rol para la persona que viene a retirar una carga ya tramitada",
    "Rol para la persona encargada de hacer el visado de la carga"
]

# Crear roles predeterminados
# Luego de crear roles, comentar la funcion para evitar crear roles duplicados
# @csrf_exempt
# def create_default_roles(request):
#     if request.method == 'POST':
#         for nombre, descripcion in zip(DEFAULT_ROLES, DESCRIPCIONES):
#             try:
#                 Roles.objects.get_or_create(
#                     nombre=nombre,
#                     defaults={'descripcion': descripcion}
#                 )
#             except Exception as e:
#                 return JsonResponse({'error': str(e)}, status=500)
#         return JsonResponse({'message': 'Default roles created successfully'})

# Crear un rol
# def create_roles(request):
#     if request.method == 'POST':
#         try:
#             data = request.POST
#             required_fields = ['nombre', 'descripcion']
#             for field in required_fields:
#                 if not data.get(field):
#                     return JsonResponse({'error': f'Missing required field: {field}'}, status=400)
#             rol = Roles(
#                 nombre=data.get('nombre'),
#                 descripcion=data.get('descripcion')
#             )

#             rol.save()
#             return JsonResponse({'message': 'Rol creado con exito', 'rol': rol.nombre})
#         except IntegrityError:
#             return JsonResponse({'error': 'Rol ya existe'}, status=400)
#         except ValidationError as e:
#             return JsonResponse({'error': str(e)}, status=400)
#         except json.JSONDecodeError:
#             return JsonResponse({'error': 'Invalid JSON format'}, status=400)
#         except Exception as e:
#             return JsonResponse({'error': str(e)}, status=500)
#     else:
#         return JsonResponse({'error': 'Invalid request method'}, status=405)


# def create_test_user_with_visado_role(request):
#     try:
#         # Create a local user
#         local_user = FirebaseUser.objects.create(
#             uid=None,
#             email="testvisado@example.com",
#             display_name="Test Visado User",
#             phone_number="1234567890",
#             photo_url=None,
#             disabled=False,
#             is_local_user=True,
#             password="password123"
#         )

#         # Assign the "Visado" role to the user
#         visado_role = Roles.objects.get(nombre="Visado")
#         visado_role.id_usuarios.add(local_user)

#         return JsonResponse({'message': 'Test user with Visado role created successfully', 'user': local_user.email})
#     except Roles.DoesNotExist:
#         return JsonResponse({'error': 'Visado role not found'}, status=404)
#     except Exception as e:
#         return JsonResponse({'error': str(e)}, status=500)

# Seccion de tramites

# Subseccion de creacion de tipos de archivos
DEFAULT_TIPOS_ARCHIVOS = [
    "Boleta de pago",
    "Archivo de retiro",
    "Carnet",
    "Carnet de conductor",
    "Archivo de informacion de aduanas",
    "Archivo de visado"
]
DESCRIPCIONES_TIPOS_ARCHIVOS = [
    "Boleta de pago de la carga",
    "Archivo que acredita el retiro de la carga",
    "Carnet de identidad",
    "Carnet de conductor",
    "Archivo con informacion de aduanas",
    "Archivo con visado de la carga"
]

# # Crear tipos de archivos predeterminados
# @csrf_exempt
# # @token_required
# def create_file_types(request):
#     if request.method == 'POST':
#         for tipo, descripcion in zip(DEFAULT_TIPOS_ARCHIVOS, DESCRIPCIONES_TIPOS_ARCHIVOS):
#             try:
#                 TipoArchivo.objects.get_or_create(
#                     name=tipo,
#                     defaults={'description': descripcion}
#                 )
#             except Exception as e:
#                 return JsonResponse({'error': str(e)}, status=500)
#         return JsonResponse({'message': 'Default file types created successfully'})

# e.g., "FCL DIRECTO", "FCL INDIRECTO", "LCL DIRECTO", "LCL INDIRECTO"
DEFAULT_TIPOS_TRAMITES = [
    "FCL DIRECTO",
    "FCL INDIRECTO",
    "LCL DIRECTO",
    "LCL INDIRECTO"
]

DESCRIPCIONES_TIPOS_TRAMITES = [
    "Tramite para contenedor de carga completa FCL directa",
    "Tramite para contenedor de carga completa FCL indirecta",
    "Tramite para carga inferior a un contenedor LCL directa",
    "Tramite para carga inferior a un contenedor LCL directa"
]

# @csrf_exempt
# def create_tramite_types(request):
#     if request.method == 'POST':
#         for tipo, descripcion in zip(DEFAULT_TIPOS_TRAMITES, DESCRIPCIONES_TIPOS_TRAMITES):
#             try:
#                 TramiteType.objects.get_or_create(
#                     name=tipo,
#                     defaults={'description': descripcion}
#                 )
#             except Exception as e:
#                 return JsonResponse({'error': str(e)}, status=500)
#         return JsonResponse({'message': 'Default tramite types created successfully'})
