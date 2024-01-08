import os

CONFIG = {
    'zerocap_portal': {
        'URL': f"{os.environ['FIREBLOCKS_URL']}",
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
            'SLACK_API_EVENTS': '/T900YRUTS/B018BDHMHHT/Ou6OHWI5yKEMgwcsp3dCrnKX',
            'SLACK_API_NOTIFICATIONS': '/T900YRUTS/B01DUGK57AQ/sSV074xCm9C59cvON8yjZBsV',
            'SLACK_API_OPS': os.environ.get('SLACK_API_OPS'),
            'SLACK_API_OPS_NOTIFICATIONS': '/TM56HT5V5/B01HKEPFTPV/tToel3L0B9WaUP2PhEq3TGdI',
            'SLACK_API_OPS_MONITOR': '/TM56HT5V5/B02KDNMLJBX/nH614wA5LgLtj5UjkxzsID2e',
            'SLACK_API_PANDADOC_NOTIFICATIONS': os.environ['SLACK_API_PANDADOC_NOTIFICATIONS'],
            'SLACK_TRANSACTION_NOTIFICATIONS': '/T900YRUTS/B02J5JRE4CU/GT3KL91yk5RzDUQxF5jnpOOR',
            'SLACK_RISK_NOTIFICATIONS': '/T900YRUTS/B03SVMB7MSP/tuPDsRcbL0BYi1TFmUuIYdZl',
        },
        'CONFIG_GATEWAY': {
            'zerocap_portal': {
                # 'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_portal_20211130.key",
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/fireblocks.key",
                'API_KEY': os.environ.get('FIREBLOCKS_API_KEY'),
            },
            'zerocap_staking': {
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_5.key",
                'API_KEY': os.environ.get('FIREBLOCKS_STAKING_API_KEY'),
            },
            'zerocap_prop_trading': {
                # 'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_prop_trading_20211130.key",
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_prop_trading.key",
                'API_KEY': os.environ.get('FIREBLOCKS_PROP_TRADING_API_KEY'),
            },
            'Zerocap': {
                # 'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_portal_20211130.key",
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_20211202.key",
                'API_KEY': os.environ.get('FIREBLOCKS_ZEROCAP_API_KEY'),
            },
        },
        'CONFIG_ASSET': {
            'ASSET_LST': ['BTC', 'ETH', 'USDT_ERC20', 'PAXG', 'USDC', 'DOT'],
            # 测试币映射关系
            'ASSET_MAPPING': {
                'BTC': 'BTC',
                'ETH': 'ETH',
                'USDT_ERC20': 'USDT',
                'PAXG': 'PAXG',
                'USDC': 'USDC',
                'AAVE': 'AAVE',
                'COMP': 'COMP',
                'UNI': 'UNI',
                'SUSHI': 'SUSHI',
                'YFI': 'YFI',
                'MKR': 'MKR',
                'RUNE': 'RUNE',
                'REN': 'REN',
                'ALPHA': 'ALPHA',
                'DOT': 'DOT',
                'SNX': 'SNX',
            }
        },
        'ZEROCAP_OTC_MAPPING': {
            "zerocap": {
                'vault_id': '3',
                'workspace': 'Zerocap',
                'internal_wallet_to_zerocap_portal': '6e35850f-3e20-4307-ab58-91efadfe9ace',
                'internal_wallet_to_zerocap_staking': 'ac429c3e-0c1b-45cf-b4a9-8b95962e1957'
            },
            "vesper": {
                'vault_id': '44',
                'workspace': 'Zerocap',
                'internal_wallet_to_zerocap_portal': '1e7bf39e-ae2b-4b0b-a463-9a9d5a3ac4eb',
                'internal_wallet_to_zerocap_staking': '04877968-044b-406e-91b6-1e389d63cf91'
            }
        },
        'TALOS_TRADE_KEYS': [
            {
                "public_key": os.environ.get('TALOS_PUBLIC_KEY'),
                "private_key": os.environ.get('TALOS_PRIVATE_KEY')
            }
        ],
        'SG_API_KEY': f"{os.environ['SG_API_KEY']}",
        'TRADE_MANAGER_EMAIL': ('william@zerocap.com', 'William Fong'),
        'COMPANY_MANAGER_EMAIL': {'william@zerocap.com': 'William Fong',
                                  'ryan@zerocap.com': 'Ryan McCall',
                                  'jon@zerocap.com': 'Jon de Wet',
                                  'trent@zerocap.com': 'Trent Barnes'},
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
            'ERC20': 'USDT_ERC20',
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
        'URL': f"https://viva.zerocap.com/#/",
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
            'SLACK_API_EVENTS': '/T900YRUTS/B018BDHMHHT/Ou6OHWI5yKEMgwcsp3dCrnKX',
            'SLACK_API_NOTIFICATIONS': '/T900YRUTS/B01DUGK57AQ/sSV074xCm9C59cvON8yjZBsV',
            'SLACK_API_OPS': os.environ.get('SLACK_API_OPS'),
            'SLACK_API_OPS_NOTIFICATIONS': '/TM56HT5V5/B01HKEPFTPV/tToel3L0B9WaUP2PhEq3TGdI',
            'SLACK_API_OPS_MONITOR': '/T900YRUTS/B02DWMDJHHT/sc2v4aNYPnyl0FrIvUPicSsp',
            'SLACK_API_PANDADOC_NOTIFICATIONS': os.environ['SLACK_API_PANDADOC_NOTIFICATIONS'],
            'SLACK_TRANSACTION_NOTIFICATIONS': '/T900YRUTS/B02J5JRE4CU/GT3KL91yk5RzDUQxF5jnpOOR',
            'SLACK_RISK_NOTIFICATIONS': '/T900YRUTS/B03SVMB7MSP/tuPDsRcbL0BYi1TFmUuIYdZl',
        },
        'CONFIG_GATEWAY': {
            'zerocap_portal': {
                # 'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_portal_20211130.key",
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/fireblocks.key",
                'API_KEY': os.environ.get('FIREBLOCKS_API_KEY'),
            },
            'zerocap_staking': {
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_5.key",
                'API_KEY': os.environ.get('FIREBLOCKS_STAKING_API_KEY'),
            },
            'zerocap_prop_trading': {
                # 'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_prop_trading_20211130.key",
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_prop_trading.key",
                'API_KEY': os.environ.get('FIREBLOCKS_PROP_TRADING_API_KEY'),
            },
            'Zerocap': {
                # 'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_portal_20211130.key",
                'FIREBLOCKS_KEY_PATH': f"{os.environ['HOME']}/zerocap_20211202.key",
                'API_KEY': os.environ.get('FIREBLOCKS_ZEROCAP_API_KEY'),
            },
        },
        'CONFIG_ASSET': {
            'ASSET_LST': ['BTC', 'ETH', 'USDT_ERC20', 'PAXG', 'USDC', 'DOT'],
            # 测试币映射关系
            'ASSET_MAPPING': {
                'BTC': 'BTC',
                'ETH': 'ETH',
                'USDT_ERC20': 'USDT',
                'PAXG': 'PAXG',
                'USDC': 'USDC',
                'AAVE': 'AAVE',
                'COMP': 'COMP',
                'UNI': 'UNI',
                'SUSHI': 'SUSHI',
                'YFI': 'YFI',
                'MKR': 'MKR',
                'RUNE': 'RUNE',
                'REN': 'REN',
                'ALPHA': 'ALPHA',
                'DOT': 'DOT',
                'SNX': 'SNX',
            }
        },
        'ZEROCAP_OTC_MAPPING': {
            "zerocap": {
                'vault_id': '3',
                'workspace': 'Zerocap',
                'internal_wallet_to_zerocap_portal': '6e35850f-3e20-4307-ab58-91efadfe9ace',
                'internal_wallet_to_zerocap_staking': 'ac429c3e-0c1b-45cf-b4a9-8b95962e1957'
            },
            "vesper": {
                'vault_id': '44',
                'workspace': 'Zerocap',
                'internal_wallet_to_zerocap_portal': '1e7bf39e-ae2b-4b0b-a463-9a9d5a3ac4eb',
                'internal_wallet_to_zerocap_staking': '04877968-044b-406e-91b6-1e389d63cf91'
            }
        },
        'TALOS_TRADE_KEYS': [
            {
                "public_key": os.environ.get('TALOS_PUBLIC_KEY'),
                "private_key": os.environ.get('TALOS_PRIVATE_KEY')
            }
        ],
        'SG_API_KEY': f"{os.environ['SG_API_KEY']}",
        'TRADE_MANAGER_EMAIL': ('william@zerocap.com', 'William Fong'),
        'COMPANY_MANAGER_EMAIL': {'william@zerocap.com': 'William Fong',
                                  'ryan@zerocap.com': 'Ryan McCall',
                                  'jon@zerocap.com': 'Jon de Wet',
                                  'trent@zerocap.com': 'Trent Barnes'},
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
            'ERC20': 'USDT_ERC20',
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
