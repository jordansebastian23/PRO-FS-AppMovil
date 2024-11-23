from difflib import SequenceMatcher
from PIL import Image
import re

import cv2
from pdf2image import convert_from_path
import pytesseract

def extract_boleta_data(text):
    data = {}
    # Extract "Total" amount
    total_match = re.search(r"Total:\s*([\d.,]+)", text)
    data["Total"] = total_match.group(1) if total_match else None
    # Extract "Domicilio" address
    domicilio_match = re.search(r"Domicilio:\s*([^\n]+)", text)
    data["Domicilio"] = domicilio_match.group(1) if domicilio_match else None
    # Extract "Rut" value
    rut_match = re.search(r"RUT:\s*([\d.-]+)", text)
    data["Rut"] = rut_match.group(1) if rut_match else None

    # Extract "N °" number
    numero_match = re.search(r"N °\s*(\d+)", text)
    data["Numero"] = numero_match.group(1) if numero_match else None
    # Extract "Fecha"
    fecha_match = re.search(r"Fecha:\s*([^\n]+)", text)
    data["Fecha"] = fecha_match.group(1) if fecha_match else None
    return data

def extract_carnet_data(text):
    data = {}
    # Extract "RUN" using a flexible format (e.g., "RUN 12.749.625-K")
    run_match = re.search(r"RUN\s+([\d.]+-[\dkK])", text, re.IGNORECASE)
    data["RUN"] = run_match.group(1) if run_match else None
    # Extract full name - Assuming names appear on two separate lines with potential first and last names
    # Example: Name pattern "FirstName MiddleName LastName"
    name_match = re.findall(r"[A-Z]{2,}\s+[A-Z]{2,}", text)
    data["Full Name"] = " ".join(name_match[:2]) if name_match else None
    # Extract date of birth or issue date (look for patterns like "21 FEB 1982")
    dob_match = re.search(r"\b(\d{1,2}\s+[A-Z]{3}\s+\d{4})\b", text)
    data["Date of Birth"] = dob_match.group(1) if dob_match else None
    # Extract expiry or issue dates (look for two dates - issued and expiry dates)
    dates_match = re.findall(r"\b(\d{1,2}\s+[A-Z]{3}\s+\d{4})\b", text)
    if len(dates_match) >= 2:
        data["Issue Date"], data["Expiry Date"] = dates_match[0], dates_match[1]
    else:
        data["Issue Date"], data["Expiry Date"] = (None, None)
    return data

def is_similar(text1, text2, threshold=0.9):
    """Return True if the similarity ratio of two strings is above the threshold."""
    return SequenceMatcher(None, text1, text2).ratio() > threshold

def preprocess_image(image_path):
    img = cv2.imread(image_path, cv2.IMREAD_COLOR)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    _, thresh = cv2.threshold(gray, 150, 255, cv2.THRESH_BINARY_INV)
    denoised = cv2.fastNlMeansDenoising(thresh, None, 30, 7, 21)
    return denoised

def extract_text_with_ocr(image_path):
    # Preprocess the image
    preprocessed_image = preprocess_image(image_path)
    # Convert the numpy array to a PIL Image
    pil_image = Image.fromarray(preprocessed_image)
    # Perform OCR on the PIL Image
    return pytesseract.image_to_string(pil_image)

def convert_pdf_to_jpg(pdf_path):
    # No need to specify poppler_path explicitly on Linux Docker if it's installed in the default location
    images = convert_from_path(pdf_path)  
    image_path = pdf_path.replace('.pdf', '.jpg')
    images[0].save(image_path, 'JPEG')
    return image_path
