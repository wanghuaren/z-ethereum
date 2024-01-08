import os

CONFIG = {
    'zerocap_portal': {
        'URL': 'https://defi.wiki/#/',
        'CONFIG_POSTGRES': {
            'USER': f"{os.environ['FIREBLOCKS_DB_USER']}",
            'PASSWORD': f"{os.environ['FIREBLOCKS_DB_PASSWORD']}",
            'HOST': f"{os.environ['FIREBLOCKS_DB_HOST']}",
            'PORT': '5432',
            'DATABASE': f"{os.environ['FIREBLOCKS_DB_NAME']}",
            'HQ_DATABASE': f"{os.environ['FIREBLOCKS_HQ_DB_NAME']}",
        },
        'CONFIG_DMA_REDIS': {
            'HOST': os.environ.get('DMA_REDIS_HOST'),
            'PORT': os.environ.get('DMA_REDIS_PORT'),
            'DB': 0,
            'DB_FOR_QUEUE': 2,
            'DB_FOR_DMA': 11
        },
        'CONFIG_REDIS': {
            'HOST': os.environ.get('REDIS_HOST'),
            'PORT': os.environ.get('REDIS_PORT'),
            'DB': 0,
            'DB_FOR_QUEUE': 2
        },
        'CONFIG_SYSTEM': {
            'DEBUG': True
        },
        'CONFIG_SLACK': {
            'SLACK_API_EVENTS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_API_NOTIFICATIONS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_API_OPS': os.environ.get('SLACK_API_OPS'),
            'SLACK_API_OPS_NOTIFICATIONS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_API_OPS_MONITOR': '/TM56HT5V5/B02KDNMLJBX/nH614wA5LgLtj5UjkxzsID2e',
            'SLACK_API_PANDADOC_NOTIFICATIONS': os.environ['SLACK_API_PANDADOC_NOTIFICATIONS'],
            'SLACK_TRANSACTION_NOTIFICATIONS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_RISK_NOTIFICATIONS': '/TM56HT5V5/B02C5H6L58U/iQ1YZ0JU6BSJI19cSlAI2bKL',
        },
        'CONFIG_GATEWAY': {
            'zerocap_portal':{
                'FIREBLOCKS_KEY_PATH': os.path.join(os.environ["HOME"], "zerocap_api_test_api_user_3.key"),
                'API_KEY': '2a9f2aa1-412b-ae52-2af8-f77f53e92306',
            },
            'zerocap_staking':{
                'FIREBLOCKS_KEY_PATH': os.path.join(os.environ["HOME"], "zerocap_api_test_2_api_user_2.key"),
                'API_KEY': 'd7525bcb-7261-3a12-93fa-39733e5000e7',
            },
            'zerocap_staking1':{
                'FIREBLOCKS_KEY_PATH': os.path.join(os.environ["HOME"], "zerocap_api_test_2_api_user_2.key"),
                'API_KEY': 'd7525bcb-7261-3a12-93fa-39733e5000e7',
            },
            'Zerocap': {
                'FIREBLOCKS_KEY_PATH': os.path.join(os.environ["HOME"], "zerocap_api_test_api_user_3.key"),
                'API_KEY': '2a9f2aa1-412b-ae52-2af8-f77f53e92306',
            },
        },
        'CONFIG_ASSET': {
            'ASSET_LST': ['WND', 'BTC_TEST', 'ETH_TEST3', 'USDC_TEST3'],
            # 测试币映射关系
            'ASSET_MAPPING': {
                'BTC_TEST': 'BTC',
                'ETH_TEST3': 'ETH',
                'USDC_TEST3': 'USDC',
                'WND': 'DOT',
                'USDT_ETH_TEST3_EA4E': 'USDT',
                'USDT_TRX_TEST4': 'TRX_USDT_S2UZ',
                'TRX_TEST': 'TRX',
                'USDT_BSC_TEST': 'USDT_BSC',
                'BNB_TEST': 'BNB_BSC'
            }
        },
        'TALOS_TRADE_KEYS': [
            {
                "public_key": os.environ.get('TALOS_PUBLIC_KEY'),
                "private_key": os.environ.get('TALOS_PRIVATE_KEY')
            }
        ],
        'SG_API_KEY': f"{os.environ['SG_API_KEY']}",
        'TRADE_MANAGER_EMAIL': ('haojiang.dong@eigen.capital', 'William Fong'),
        'COMPANY_MANAGER_EMAIL': {'haojiang.dong@eigen.capital': 'Ryan McCall',
                                  'qinghua.zhao@eigen.capital': 'Jon de Wet',
                                  'yong.ma@eigen.capital': 'Trent Barnes'},
        'MARKETS_LIST': {
            # 可下单(live hedge)
            "PLACE": {"b2c2": "B2C2", "galaxy": "Galaxy", "cumberland": "Cumberland"},
            # 不可下单(Add/Edit Txns)
            "NO_PLACE": {
                # talos
                "wintermute": "Wintermute", "crypto.com": "Crypto.com", "monoova": "Monoova",
                "ftxexchangetalossubaccount": "FTX Exchange Talos Subaccount", "24exchange": "24 Exchange",
                # ccxt
                "binance": "Binance", "kucoin": "Kucoin", "gate": "Gate", "okx": "OKX", "mexc": "MEXC",
                # 其他
                "sucden": "Sucden", "amber": "Amber", "trigonX": "TrigonX", "coinbase": "Coinbase",  
                "ftxotc": "FTX OTC", "circle": "Circle", "gck": "CoinGecko", "velocity": "Velocity", 
                "enigma": "Enigma", "kraken": "Kraken", "1konto": "1KONTO", "bonex": "Ebonex",
                "osl": "OSL", "falconx": "FalconX", "independentreserve": "Independent Reserve",
                "bullishexchange": "Bullish Exchange", "monex": "Monex", "janestreet": "Jane Street",
                "bybit": "Bybit", "crossx": "CrossX", "paxos": "Paxos", "bankfrick": "Bank Frick", 
                "fomopay": "Fomo Pay", "coinbaseconversion": "Coinbase Conversion"},
            "CALCULATOR": {
                # talos
                "b2c2": "B2C2", "cumberland": "Cumberland", "galaxy": "Galaxy",
                "dvchain": "DVChain", "okcoin": "Okcoin", "flowtraders": "Flow Traders",
                "wintermute": "Wintermute", "crypto.com": "Crypto.com", "monoova": "Monoova",
                "ftxexchangetalossubaccount": "FTX Exchange Talos Subaccount", 
                # ccxt
                "binance": "Binance", "kucoin": "Kucoin", "gate": "Gate", "okx": "OKX", "mexc": "MEXC",
            },
            # 可询价(GetQuote)
            "RFQ": { "b2c2": "B2C2", "cumberland": "Cumberland", 
                    "dvchain": "DVChain",  "galaxy": "Galaxy", "okcoin": "Okcoin", "flowtraders": "Flow Traders",
                    # ccxt
                    "binance": "Binance", "kucoin": "Kucoin", "gate": "Gate", "okx": "OKX", "mexc": "MEXC"},
            # 价格补充，不在任何页面显示
            "SUPPLEMENT": {
                # ccxt -- 不在市场列表显示
                "yahoo": "YaHoo"
            }
        },
        'ZEROCAP_OTC_MAPPING': {
            "zerocap": {
                'vault_id': '38',
                'workspace': 'Zerocap',
                # zerocap_portal 工作区转到 OTC 的 Zerocap
                'internal_wallet_to_zerocap_portal': '493b035e-2c1b-4d13-8e70-54dfecd566a4',
                # zerocap_staking 工作区转到 OTC 的 Zerocap
                'internal_wallet_to_zerocap_staking': '0a157a39-1815-409b-a7f0-0b8c845a78ab'
            },
            "vesper": {
                'vault_id': '222',
                'workspace': 'Zerocap',
                # zerocap_portal 工作区转到 OTC 的 visper
                'internal_wallet_to_zerocap_portal': '378678e0-cf29-427f-a271-a7498fbf52ba',
                # zerocap_staking 工作区转到 OTC 中 visper
                'internal_wallet_to_zerocap_staking': '6d7b9ba9-b1fc-4d6b-9460-5deb78400eb7'
            }
        },
        'USDT': {
            'ERC20': 'USDT',
            'TRC20': 'TRX_USDT_S2UZ',
            'EBP-20': 'USDT_BSC'
        },
        'SG_TEMPLATE_MAPPING': {
            "fiat_altcoin_transfer": {
                "id": "d-0e6f28f861984a93ac7db348b78700b3"
            },
            "new_fiat_altcoin_transfer": {
                "id": "d-286a4f797b884421b3e4153000193b06"
            }
        },
        'EMAIL_GUARD_TIME': 0,
    },
    'viva': {
        'URL': 'https://defi.wiki/#/',
        'CONFIG_POSTGRES': {
            'USER': f"{os.environ['FIREBLOCKS_DB_USER']}",
            'PASSWORD': f"{os.environ['FIREBLOCKS_DB_PASSWORD']}",
            'HOST': f"{os.environ['FIREBLOCKS_DB_HOST']}",
            'PORT': '5432',
            'DATABASE': f"{os.environ['FIREBLOCKS_DB_NAME']}",
        },
        'CONFIG_DMA_REDIS': {
            'HOST': os.environ.get('DMA_REDIS_HOST'),
            'PORT': os.environ.get('DMA_REDIS_PORT'),
            'DB': 0,
            'DB_FOR_QUEUE': 2,
            'DB_FOR_DMA': 11
        },
        'CONFIG_REDIS': {
            'HOST': os.environ.get('REDIS_HOST'),
            'PORT': os.environ.get('REDIS_PORT'),
            'DB': 0,
            'DB_FOR_QUEUE': 2
        },
        'CONFIG_SYSTEM': {
            'DEBUG': True
        },
        'CONFIG_SLACK': {
            'SLACK_API_EVENTS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_API_NOTIFICATIONS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_API_OPS': os.environ.get('SLACK_API_OPS'),
            'SLACK_API_OPS_NOTIFICATIONS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_API_OPS_MONITOR': '/TM56HT5V5/B02KDNMLJBX/nH614wA5LgLtj5UjkxzsID2e',
            'SLACK_API_PANDADOC_NOTIFICATIONS': os.environ['SLACK_API_PANDADOC_NOTIFICATIONS'],
            'SLACK_TRANSACTION_NOTIFICATIONS': '/TM56HT5V5/B018VSPQ89E/8GBphKjjtQPaOFQ4gi8rlNFN',
            'SLACK_RISK_NOTIFICATIONS': '/TM56HT5V5/B02C5H6L58U/iQ1YZ0JU6BSJI19cSlAI2bKL',
        },
        'CONFIG_GATEWAY': {
            'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/fireblocks.key",
            'API_KEY': '832a9c33-e48b-49bb-8fbd-7b31051e39f3',
        },
        'CONFIG_ASSET':  {
            'ASSET_LST': ['WND', 'BTC_TEST', 'ETH_TEST3', 'USDC_TEST3'],
            # 测试币映射关系
            'ASSET_MAPPING': {
                'BTC_TEST': 'BTC',
                'ETH_TEST3': 'ETH',
                'USDC_TEST3': 'USDC',
                'WND': 'DOT',
                'USDT_ETH_TEST3_EA4E': 'USDT',
                'USDT_TRX_TEST4': 'TRX_USDT_S2UZ',
                'TRX_TEST': 'TRX',
                'USDT_BSC_TEST': 'USDT_BSC',
                'BNB_TEST': 'BNB_BSC'
            }
        },
        'ZEROCAP_OTC_MAPPING': {
            "zerocap": {
                'vault_id': '38',
                'workspace': 'Zerocap',
                # zerocap_portal 工作区转到 OTC 的 Zerocap
                'internal_wallet_to_zerocap_portal': '493b035e-2c1b-4d13-8e70-54dfecd566a4',
                # zerocap_staking 工作区转到 OTC 的 Zerocap
                'internal_wallet_to_zerocap_staking': '0a157a39-1815-409b-a7f0-0b8c845a78ab'
            },
            "vesper": {
                'vault_id': '222',
                'workspace': 'Zerocap',
                # zerocap_portal 工作区转到 OTC 的 visper
                'internal_wallet_to_zerocap_portal': '378678e0-cf29-427f-a271-a7498fbf52ba',
                # zerocap_staking 工作区转到 OTC 中 visper
                'internal_wallet_to_zerocap_staking': '6d7b9ba9-b1fc-4d6b-9460-5deb78400eb7'
            }
        },
        'TALOS_TRADE_KEYS': [
            {
                "public_key": os.environ.get('TALOS_PUBLIC_KEY'),
                "private_key": os.environ.get('TALOS_PRIVATE_KEY')
            }
        ],
        'SG_API_KEY': f"{os.environ['SG_API_KEY']}",
        'TRADE_MANAGER_EMAIL': ('haojiang.dong@eigen.capital', 'William Fong'),
        'COMPANY_MANAGER_EMAIL': {'haojiang.dong@eigen.capital': 'Ryan McCall',
                                  'qinghua.zhao@eigen.capital': 'Jon de Wet',
                                  'yong.ma@eigen.capital': 'Trent Barnes'},
        'MARKETS_LIST': {
            # 可下单(live hedge)
            "PLACE": {"b2c2": "B2C2", "galaxy": "Galaxy", "cumberland": "Cumberland"},
            # 不可下单(Add/Edit Txns)
            "NO_PLACE": {
                # talos
                "wintermute": "Wintermute", "crypto.com": "Crypto.com", "monoova": "Monoova",
                "ftxexchangetalossubaccount": "FTX Exchange Talos Subaccount", "24exchange": "24 Exchange", 
                # ccxt
                "binance": "Binance", "kucoin": "Kucoin", "gate": "Gate", "okx": "OKX", "mexc": "MEXC",
                # 其他
                "sucden": "Sucden", "amber": "Amber", "trigonX": "TrigonX", "coinbase": "Coinbase",  
                "ftxotc": "FTX OTC", "circle": "Circle", "gck": "CoinGecko", "velocity": "Velocity", 
                "enigma": "Enigma", "kraken": "Kraken", "1konto": "1KONTO", "bonex": "Ebonex",
                "osl": "OSL", "falconx": "FalconX", "independentreserve": "Independent Reserve",
                "bullishexchange": "Bullish Exchange", "monex": "Monex", "janestreet": "Jane Street",
                "bybit": "Bybit", "crossx": "CrossX", "paxos": "Paxos", "bankfrick": "Bank Frick", 
                "fomopay": "Fomo Pay", "coinbaseconversion": "Coinbase Conversion"},
            "CALCULATOR": {
                # talos
                "b2c2": "B2C2", "cumberland": "Cumberland", "galaxy": "Galaxy",
                "dvchain": "DVChain", "okcoin": "Okcoin", "flowtraders": "Flow Traders",
                "wintermute": "Wintermute", "crypto.com": "Crypto.com", "monoova": "Monoova",
                "ftxexchangetalossubaccount": "FTX Exchange Talos Subaccount", 
                # ccxt
                "binance": "Binance", "kucoin": "Kucoin", "gate": "Gate", "okx": "OKX", "mexc": "MEXC",
            },
            # 可询价(GetQuote)
            "RFQ": {"b2c2": "B2C2", "cumberland": "Cumberland", 
                    "dvchain": "DVChain",  "galaxy": "Galaxy", "okcoin": "Okcoin", "flowtraders": "Flow Traders",
                    # ccxt
                    "binance": "Binance", "kucoin": "Kucoin", "gate": "Gate", "okx": "OKX", "mexc": "MEXC"},
            # 价格补充，不在任何页面显示
            "SUPPLEMENT": {
                # ccxt -- 不在市场列表显示
                "yahoo": "YaHoo"
            }
        },
        'USDT': {
            'ERC20': 'USDT',
            'TRC20': 'TRX_USDT_S2UZ',
            'EBP-20': 'USDT_BSC'
        },
        'SG_TEMPLATE_MAPPING': {
            "fiat_altcoin_transfer": {
                "id": "d-0e6f28f861984a93ac7db348b78700b3"
            },
            "new_fiat_altcoin_transfer": {
                "id": "d-286a4f797b884421b3e4153000193b06"
            }
        },
        'EMAIL_GUARD_TIME': 0,
    }
}
