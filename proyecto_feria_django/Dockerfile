FROM python:3.12.6

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt && \
    apt-get update && apt-get install -y \
    tesseract-ocr \
    poppler-utils \
    libgl1-mesa-glx \
    libglib2.0-0 && \
    rm -rf /var/lib/apt/lists/*

RUN pip install opencv-python-headless


# Copy the project
COPY . /app/

# Expose the port the app runs on
EXPOSE 8000

ENV TESSERACT_CMD=/usr/bin/tesseract


# Run the project
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
