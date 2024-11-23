from celery import shared_task
from ml.services import compare_file_service

@shared_task
def compare_file_task(file_url, template_type):
    return compare_file_service(file_url, template_type)