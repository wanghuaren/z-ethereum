import traceback
from utils.logger import logger
from utils.zc_exception import ZCException
from celery_async_task.celery_app import app
from celery.result import AsyncResult


def send_task_to_queue(**kwargs):
    try:
        logger.info(f'send_task_to_queue start: data_type=>{kwargs["data_type"]}, operate=>{kwargs["operate"]}, '
                    f'new_alias=>{kwargs["new_alias"]}, old_alias=>{kwargs["old_alias"]}')
        app.send_task(f"tasks.async_tasks.blotter_tasks.blotter_handle", queue='ems_queue', kwargs=kwargs)
        logger.info('send_task_to_queue end')
    except Exception:
        logger.error(traceback.format_exc())


if __name__ == '__main__':
    parameter = {
        "txn_alias": "73e90ddd-8b9b-4068-b9ab-4e3531fbcf15",
        "quantity": "100",
        "operate": "add_blotter"
    }
    send_task_to_queue(**parameter)


