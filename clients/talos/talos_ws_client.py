from clients.talos.talos_base_client import TalosBaseClient
# from execution.clients.utils import logger


class TalosWebSocketClient(TalosBaseClient):
    """
    talos ws client process
    """

    def __init__(self):
        super().__init__()

        self.path = "/ws/v1"
        self.endpoint = f"wss://{self.host}{self.path}"
        # logger.info(self.endpoint)

        self.header = self.build_headers(self.path)
        # logger.info(self.header)
