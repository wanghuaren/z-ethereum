import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

# celery -A celery_async_task.tasks worker -l info -P gevent

from celery import Celery
from celery_async_task import celery_config

app = Celery()
app.config_from_object(celery_config)
