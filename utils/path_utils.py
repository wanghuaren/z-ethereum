from pathlib import Path


class PathConst:
    BASE_DIR = Path(__file__).parent.parent.absolute()

    PROTO_FILE = BASE_DIR.joinpath('otc.proto')

    LOG_DIR = BASE_DIR.joinpath('logs')

    OTC_LOCK = LOG_DIR.joinpath('otc.lock')
