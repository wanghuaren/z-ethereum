from grpc_tools import protoc

from config.config import zmdpath, omdpath, emsPath
from utils.path_utils import PathConst

for pf in [str(PathConst.PROTO_FILE)]:
    protoc.main(
        (
            '',
            f'-I={str(PathConst.BASE_DIR)}',
            f'--python_out={str(PathConst.BASE_DIR)}',
            f'--grpc_python_out={str(PathConst.BASE_DIR)}',
            f'{pf}',
        )
    )

protoc.main(
    (
        '',
        '-I='+zmdpath,
        '--python_out=.',
        '--grpc_python_out=.',
        'zerocap_market_data.proto',
    )
)

# protoc.main(
#     (
#         '',
#         '-I='+omdpath,
#         '--python_out=.',
#         '--grpc_python_out=.',
#         'market_data.proto',
#     )
# )

protoc.main(
    (
        '',
        '-I='+emsPath,
        '--python_out=.',
        '--grpc_python_out=.',
        'exec.proto',
    )
)

protoc.main(
    (
        '',
        '-I='+emsPath,
        '--python_out=.',
        '--grpc_python_out=.',
        'admin.proto',
    )
)

