FROM python:3.12.6

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt /app/

# Install dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the project
COPY . /app/

# Expose the port the app runs on
EXPOSE 8000

# Run the project
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]