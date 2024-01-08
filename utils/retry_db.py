import traceback
from peewee import PostgresqlDatabase, InterfaceError, OperationalError
from peewee import SENTINEL
from playhouse.shortcuts import ReconnectMixin
from utils.slack_utils import send_slack
from config.config import config


class RetryPostgresqlDatabase(ReconnectMixin, PostgresqlDatabase):
    _instance = None

    def __init__(self, *args, **kwargs):
        super(RetryPostgresqlDatabase, self).__init__(*args, **kwargs)
        self._reconnect_errors[InterfaceError] = ["connection already closed unexpectedly", "connection already closed"]
        self._reconnect_errors[OperationalError] = ["could not connect to server",
                                                    "server closed the connection unexpectedly"]

    @staticmethod
    def get_db_instance():
        if not RetryPostgresqlDatabase._instance:
            RetryPostgresqlDatabase._instance = RetryPostgresqlDatabase(
                config['CONFIG_POSTGRES']['DATABASE'],
                host=config['CONFIG_POSTGRES']['HOST'],
                port=config['CONFIG_POSTGRES']['PORT'],
                user=config['CONFIG_POSTGRES']['USER'],
                password=config['CONFIG_POSTGRES']['PASSWORD'],
                autorollback=True
            )
        return RetryPostgresqlDatabase._instance

    def execute_sql(self, sql, params=None, commit=SENTINEL):
        try:
            return super(ReconnectMixin, self).execute_sql(sql, params, commit)
        except Exception as exc:

            exc_class = type(exc)
            if exc_class not in self._reconnect_errors:
                raise exc

            exc_repr = str(exc).lower()
            for err_fragment in self._reconnect_errors[exc_class]:
                if err_fragment in exc_repr:
                    break
            else:
                raise exc
            send_slack(channel='SLACK_API_OPS',
                       subject="db error",
                       content=f"{str(traceback.format_exc())}\n")
            if not self.is_connection_usable():
                self.close()
                self.connect()
                send_slack(channel='SLACK_API_OPS',
                           subject="db reconnected",
                           content=f"")
            return super(ReconnectMixin, self).execute_sql(sql, params, commit)


retry_db = RetryPostgresqlDatabase.get_db_instance()
