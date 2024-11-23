import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from core.utils import role_visado_required
from ml.tasks import compare_file_task

@csrf_exempt
@role_visado_required
def compare_file(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            file_url = data.get('file_url')
            template_type = data.get('template_type')

            if not file_url or not template_type:
                return JsonResponse({"error": "File URL or template type missing"}, status=400)

            # Offload processing to Celery task
            task = compare_file_task.delay(file_url, template_type)
            return JsonResponse({"task_id": task.id, "message": "Processing started"}, status=202)

        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)
    else:
        return JsonResponse({"error": "Method not allowed"}, status=405)