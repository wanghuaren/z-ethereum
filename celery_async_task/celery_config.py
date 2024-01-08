# config.py

from kombu import Queue, Exchange
from config.config import config

result_backend = f'redis://{config["CONFIG_REDIS"]["HOST"]}:{config["CONFIG_REDIS"]["PORT"]}/0'
broker_url = f'redis://{config["CONFIG_REDIS"]["HOST"]}:{config["CONFIG_REDIS"]["PORT"]}/1'

# 指定任务序列化方式
task_serializer = 'json'
# 指定结果序列化方式
result_serializer = 'json'
# 指定任务接受的序列化类型.
accept_content = ['json']
imports = (
    "tasks.async_tasks.blotter_tasks",
)

worker_hijack_root_logger = False
worker_redirect_stdouts = False
task_ignore_result = True
worker_concurrency = 4  # worker的并发数，默认是服务器的内核项目，也是命令行-c的指定数目目
worker_max_tasks_per_child = 200  # 每个worker执行多少任务后自动杀死，防止内存溢出

beat_exchange = Exchange('sh_beat', type='topic')
ems_exchange = Exchange('ems_queue', type='direct')

task_queues = (
    Queue('sh_beat', exchange=beat_exchange, routing_key='*.sh_beat.*', delivery_mode=1),
)