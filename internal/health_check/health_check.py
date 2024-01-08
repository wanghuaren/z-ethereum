import otc_pb2
from internal.health_check.db_connect_status import db_connect_status

all_tasks = ['db_connect_status']


def health_check(tasks):
    tasks = tasks.split(';') if tasks else all_tasks
    result = []
    for task in tasks:
        if task == 'db_connect_status':
                result.append(otc_pb2.OTCCheckHealthResult(**db_connect_status()))

    return result
