import os

environment = os.environ.get('FIREBLOCKS_ENV', 'development')
environment_config = None

zmdpath = os.environ.get('zmdPath')
omdpath = os.environ.get('marketDataPath')
emsPath = os.environ.get('emsPath')

ENV = os.environ.get('FIREBLOCKS_ENV', 'development')
TALOS_CONFIG = {
    "TALOS_API_KEY": os.environ.get('TALOS_API_KEY'),
    "TALOS_API_SECRET": os.environ.get('TALOS_API_SECRET'),
    "TALOS_URL": os.environ.get('TALOS_URL'),
    "MARKETS_ACCOUNTS": {
        'zerocap': {
            # market : account
            'b2c2': 'b2-c2',
            'dvchain': 'dv-chain',
            'cumberland': 'cumberland',
            'galaxy': 'galaxy',
            'okcoin': 'okcoin',
            'flowtraders': 'flow-traders',
        },
        'vesper': {}
    } if ENV == 'production' else {
        'zerocap': {
            # market : {}
            'b2c2': 'b2-c2-uat-zerocap',
            'dvchain': 'dvchain',
            'galaxy': 'galaxy',
            'okcoin': 'okcoin',
            'flowtraders': 'flowtraders',
            'cumberland': 'cumberland'
        },
        'vesper': {
            'b2c2': 'b2-c2-uat-vesper'
        }
    }
}

FIAT_LIST = ['AED', 'ARS', 'AUD', 'BDT', 'BHD', 'BMD', 'BRL', 'CAD', 'CHF', 'CLP', 'CNY', 'CZK',
             'DKK', 'EUR', 'GBP', 'HKD', 'HUF', 'IDR', 'ILS', 'INR', 'JPY', 'KRW', 'KWD', 'LKR',
             'MMK', 'MXN', 'MYR', 'NGN', 'NOK', 'NZD', 'PHP', 'PKR', 'PLN', 'RUB', 'SAR', 'SEK',
             'SGD', 'THB', 'TRY', 'TWD', 'UAH', 'USD', 'VEF', 'VND', 'XDR', 'ZAR']

CHANNEL_DEFAULT_ORDER = [
    "gck",
    "binance",
    "bnb",
    "okx",
    "okcoin",
    "b2c2",
    "galaxy",
    "cumberland",
    "dvchain",
    "gate",
    "mexc",
    "flowtraders",
    "kucoin",
    "cmc",
    "yahoo",
    "invest",
    "24exchange"
]

EntityTypeCompany = "company"
EntityTypeTrust = "trust"
EntityTypeGroup = "group"
EntityTypeIndividual = "individual"

OTCSupportedFiat = ["USD","AUD","EUR","GBP","NZD","CAD"]


if environment == 'development':
    from config.development import CONFIG as dev_config

    environment_config = dev_config
elif environment == 'production':
    from config.production import CONFIG as prod_config

    environment_config = prod_config

config_all = dict(environment_config)
config = dict(config_all.get(os.environ.get('FIREBLOCKS_TENANT', 'zerocap_portal')))
if('/viva_' in os.getcwd()):
    print('init viva config')
    config = dict(config_all.get('viva'))
else:
    print(f"init {os.environ.get('FIREBLOCKS_TENANT', 'zerocap_portal')} config")


# email log 配置
SystemPortal = "Portal"
SystemAdmin = "Admin"
SystemEMS = "EMS"

ModelTreasury = "Treasury"
ModelDashboard = "Dashboard"
ModelPreferences = "Preferences"
ModelHistory = "History"
ModelProductMgmt = "Product Mgmt"
ModelBackend = "Backend"
ModelActionQueue = "Action Queue"
ModelEntityMgmt = "Entity Mgmt"

SubModelTransfer = "Transfer"
SubModelCrypto = "Crypto"
SubModelDashboard = "Dashboard"
SubModelProfile = "Profile"
SubModelBankInfo = "BankInfo"
SubModelWithdrawal = "Withdrawal"
SubModelClientTransactions = "Client Transactions"
SubModelStructuredProduct = "Structured Product"
SubModelBackend = "Backend"
SubModelApprovalQueue = "Approval Queue"
SubModelStructuredMgmt = "Structured Mgmt"

OperateConfirm = "Confirm"
OperateWithdrawal = "Withdrawal"
OperateDeposit = "Deposit"
OperateLogin = "Login"
OperateAdd = "Add"
OperateEdit = "Edit"
OperateEditAdd = "Edit/Add"
OperateAutoScript = "Auto Script"
OperateSendReceipt = "Send Receipt"
OperateApprove = "Approve"
OperateSubmit = "Submit"
OperateReject = "Reject"
OperatePayment = "Add Payment"
OperateSettlement = "Add Settlement"

FromPortalAddress = "portal@zerocap.com"

EmailLogConfig = {
    "monthly_holding_statement": {
        "system": SystemAdmin,
        "model": ModelBackend,
        "sub_model": SubModelBackend,
        "operate": OperateAutoScript,
        "from_address": FromPortalAddress,
    },
    "withdrawal_confirmation": {
        "system": SystemPortal,
        "model": ModelDashboard,
        "sub_model": SubModelCrypto,
        "operate": OperateWithdrawal,
        "from_address": FromPortalAddress,
    },
    "withdrawal_rejection": {
        "system": SystemAdmin,
        "model": ModelActionQueue,
        "sub_model": SubModelApprovalQueue,
        "operate": OperateReject,
        "from_address": FromPortalAddress,
    },
    "send_receipt": {
        "system": SystemEMS,
        "model": ModelHistory,
        "sub_model": SubModelClientTransactions,
        "operate": OperateSendReceipt,
        "from_address": FromPortalAddress,
    },
    "treasury_withdrawal": {
        "system": SystemPortal,
        "model": ModelTreasury,
        "sub_model": SubModelTransfer,
        "operate": OperateWithdrawal,
        "from_address": FromPortalAddress,
    },
    "yield_weekly_interest": {
        "system": SystemAdmin,
        "model": ModelBackend,
        "sub_model": SubModelBackend,
        "operate": OperateAutoScript,
        "from_address": FromPortalAddress,
    },
    "new_portfolio_approved": {
        "system": SystemAdmin,
        "model": ModelActionQueue,
        "sub_model": SubModelApprovalQueue,
        "operate": OperateApprove,
        "from_address": FromPortalAddress,
    },
    "new_portfolio_rejected": {
        "system": SystemAdmin,
        "model": ModelActionQueue,
        "sub_model": SubModelApprovalQueue,
        "operate": OperateReject,
        "from_address": FromPortalAddress,
    },
    "Deposit": {
        "system": SystemPortal,
        "model": ModelDashboard,
        "sub_model": SubModelCrypto,
        "operate": OperateDeposit,
        "from_address": FromPortalAddress,
    },
    "withdrawal": {
        "system": SystemAdmin,
        "model": ModelActionQueue,
        "sub_model": SubModelApprovalQueue,
        "operate": OperateApprove,
        "from_address": FromPortalAddress,
    },
    "external_wallet_added": {
        "system": SystemPortal,
        "model": ModelDashboard,
        "sub_model": SubModelCrypto,
        "operate": OperateAdd,
        "from_address": FromPortalAddress,
    },
    "ems_transfer": {
        "system": SystemEMS,
        "model": ModelHistory,
        "sub_model": SubModelClientTransactions,
        "operate": OperatePayment,
        "from_address": FromPortalAddress
    }
}

Trader_Email_Abridge = {
    "kurt@zerocap.io":"KG",
    "william@zerocap.com":"WF",
    "berkeley@zerocap.com":"BC",
    "joe@zerocap.com":"JW",
    "parth@zerocap.com":"PS",
    "sam.holman@zerocap.com":"SH",
    "caleb.wong@zerocap.com":"CW",
    "denzy.rebello@zerocap.com":"DR",
    "edward.goldman@zerocap.com":"EG",
    "toby@zerocap.com":"TC",
    "jon@zerocap.com":"JD"
}

ASSETS_SETTING = {
    'fiat': {
        'quantity': 2,
        'price': 5
    },
    'stable_currency': {
        'quantity': 2,
        'price': 4
    },
    'crypto': {
        'quantity': 4,
        'price': 4
    }
}

# 市场配置分类
MARKETS_CATEGORY = ["PLACE", "NO_PLACE", "CALCULATOR", "RFQ", "SUPPLEMENT"]

# 自定义交易对币种名称
CUSTOM_ASSETS = ["USDT_TRC20", "USDT_AVAX", "USDT_ERC20", "USDT_BSC", "USDT_BSC", "USDT_POLYGON"]