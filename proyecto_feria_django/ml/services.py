import os
import boto3
import requests
from ml.utils import extract_text_with_ocr, convert_pdf_to_jpg, preprocess_image
from django.http import JsonResponse
from ml.utils import extract_carnet_data, extract_boleta_data, is_similar

# Configurar el cliente de S3
s3_client = boto3.client(
    's3',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
    region_name=os.getenv('AWS_S3_REGION_NAME')
)

def compare_file_service(file_url, template_type):
    # Download file
    file_path = f"/tmp/{file_url.split('/')[-1]}"
    try:
        response = requests.get(file_url)
        response.raise_for_status()  # Raise an error for HTTP issues
        with open(file_path, 'wb') as f:
            f.write(response.content)
        
        # Check if file was downloaded successfully
        if not os.path.exists(file_path) or os.path.getsize(file_path) == 0:
            return JsonResponse({"error": "Failed to download file or file is empty"}, status=500)
    except Exception as e:
        return JsonResponse({"error": f"Failed to download file: {e}"}, status=500)

    # Define S3 file paths for comparison
    bucket_name = os.getenv('AWS_STORAGE_BUCKET_NAME')
    if template_type == "carnet":
        comparison_key = "carnet.jpg"
    elif template_type == "boleta":
        comparison_key = "boleta_sample.pdf"
    else:
        return JsonResponse({"error": "Unknown template type"}, status=400)

    # Download the comparison file from S3
    comparison_path = f"/tmp/{comparison_key}"
    s3_client.download_file(bucket_name, comparison_key, comparison_path)

    # Convert PDF to image if needed
    if comparison_path.endswith('.pdf'):
        comparison_path = convert_pdf_to_jpg(comparison_path)

    if file_path.endswith('.pdf'):
        file_path = convert_pdf_to_jpg(file_path)

    # Perform OCR
    print("Performing OCR on" + file_path + " and " + comparison_path) 
    user_text = extract_text_with_ocr(file_path)
    print("Texto de usuario: \n " + user_text)
    comparison_text = extract_text_with_ocr(comparison_path)
    print("Texto de comparacion: \n" + comparison_text)

    # Simple comparison logic (customize as needed)
    result = {}
    if template_type == "carnet":
        user_data = extract_carnet_data(user_text)
        comparison_data = extract_carnet_data(comparison_text)

        # Compare fields
        comparison_result = {
            "RUN": user_data["RUN"] == comparison_data["RUN"],
            "Name": is_similar(user_data["Full Name"], comparison_data["Full Name"]),
            "Issue_Date": user_data["Issue Date"] == comparison_data["Issue Date"],
            "Expiry_Date": user_data["Expiry Date"] == comparison_data["Expiry Date"]
        }
    elif template_type == "boleta":
        user_data = extract_boleta_data(user_text)
        comparison_data = extract_boleta_data(comparison_text)

        # Compare extracted fields
        comparison_result = {
            "Total": user_data["Total"] == comparison_data["Total"],
            "Domicilio": user_data["Domicilio"] == comparison_data["Domicilio"],
            "Rut": user_data["Rut"] == comparison_data["Rut"],
            "Numero": user_data["Numero"] == comparison_data["Numero"],
            "Fecha": user_data["Fecha"] == comparison_data["Fecha"]
        }

    # Clean up temp files
    os.remove(file_path)
    os.remove(comparison_path)

    return JsonResponse({"comparison_result": comparison_result, "user_data": user_data, "comparison_data": comparison_data}, status=200)
