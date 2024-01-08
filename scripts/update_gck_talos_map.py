import sys
from pathlib import Path
sys.path.append(str(Path(__file__).absolute().parent.parent))

from db.models import Assets
from db.base_models import db
from utils.logger import logger

gck_talos_map_list = [
    {
        "asset": "BAR",
        "gck_id": "fc-barcelona-fan-token"
    },
    {
        "asset": "BASIC",
        "gck_id": "basic"
    },
    {
        "asset": "BAX",
        "gck_id": "babb"
    },
    {
        "asset": "BBC",
        "gck_id": "bull-btc-club"
    },
    {
        "asset": "BCD",
        "gck_id": "bitcoin-diamond"
    },
    {
        "asset": "BCPT",
        "gck_id": "blockmason-credit-protocol"
    },
    {
        "asset": "BDOT",
        "gck_id": "binance-wrapped-dot"
    },
    {
        "asset": "BDX",
        "gck_id": "beldex"
    },
    {
        "asset": "BEAR",
        "gck_id": "bear-inu"
    },
    {
        "asset": "BEAT",
        "gck_id": "metabeat"
    },
    {
        "asset": "BEL",
        "gck_id": "bella-protocol"
    },
    {
        "asset": "BEPRO",
        "gck_id": "bepro-network"
    },
    {
        "asset": "BETH",
        "gck_id": "binance-eth"
    },
    {
        "asset": "BFC",
        "gck_id": "bifrost"
    },
    {
        "asset": "BIDR",
        "gck_id": "binanceidr"
    },
    {
        "asset": "BLOK",
        "gck_id": "bloktopia"
    },
    {
        "asset": "BMON",
        "gck_id": "binamon"
    },
    {
        "asset": "BOA",
        "gck_id": "bosagora"
    },
    {
        "asset": "BOLT",
        "gck_id": "bolt"
    },
    {
        "asset": "BONDLY",
        "gck_id": "bondly"
    },
    {
        "asset": "BOT",
        "gck_id": "starbots"
    },
    {
        "asset": "BRD",
        "gck_id": "bread"
    },
    {
        "asset": "BRISE",
        "gck_id": "bitrise-token"
    },
    {
        "asset": "BSW",
        "gck_id": "biswap"
    },
    {
        "asset": "BTCB",
        "gck_id": "bitcoin-bep2"
    },
    {
        "asset": "BTCST",
        "gck_id": "btc-standard-hashrate-token"
    },
    {
        "asset": "BTS",
        "gck_id": "bitshares"
    },
    {
        "asset": "BTT",
        "gck_id": "bittorrent"
    },
    {
        "asset": "BULL",
        "gck_id": "bullieverse"
    },
    {
        "asset": "BURP",
        "gck_id": "burp"
    },
    {
        "asset": "BUX",
        "gck_id": "blockport"
    },
    {
        "asset": "BUY",
        "gck_id": "buying"
    },
    {
        "asset": "BZRX",
        "gck_id": "bzx-protocol"
    },
    {
        "asset": "LUNR",
        "gck_id": "lunr-token"
    },
    {
        "asset": "LYM",
        "gck_id": "lympo"
    },
    {
        "asset": "LYXE",
        "gck_id": "lukso-token"
    },
    {
        "asset": "MAHA",
        "gck_id": "mahadao"
    },
    {
        "asset": "MAKI",
        "gck_id": "makiswap"
    },
    {
        "asset": "MAN",
        "gck_id": "matrix-ai-network"
    },
    {
        "asset": "MANA",
        "gck_id": "decentraland"
    },
    {
        "asset": "MAP",
        "gck_id": "marcopolo"
    },
    {
        "asset": "NEER",
        "gck_id": "metaverse-network-pioneer"
    },
    {
        "asset": "NFT",
        "gck_id": "apenft"
    },
    {
        "asset": "NFTB",
        "gck_id": "nftb"
    },
    {
        "asset": "NGC",
        "gck_id": "naga"
    },
    {
        "asset": "NGL",
        "gck_id": "gold-fever-native-gold"
    },
    {
        "asset": "NGM",
        "gck_id": "e-money"
    },
    {
        "asset": "NHCT",
        "gck_id": "hurricane-nft"
    },
    {
        "asset": "NIF",
        "gck_id": "unifty"
    },
    {
        "asset": "NIM",
        "gck_id": "nimiq-2"
    },
    {
        "asset": "NOIA",
        "gck_id": "noia-network"
    },
    {
        "asset": "NOM",
        "gck_id": "onomy-protocol"
    },
    {
        "asset": "NORD",
        "gck_id": "nord-finance"
    },
    {
        "asset": "NPXS",
        "gck_id": "pundi-x"
    },
    {
        "asset": "POLYX",
        "gck_id": "polymesh"
    },
    {
        "asset": "PORTO",
        "gck_id": "fc-porto"
    },
    {
        "asset": "POSI",
        "gck_id": "position-token"
    },
    {
        "asset": "PPT",
        "gck_id": "populous"
    },
    {
        "asset": "PRE",
        "gck_id": "presearch"
    },
    {
        "asset": "PRIMAL",
        "gck_id": "primal-b3099cd0-995a-4311-80d5-9c133153b38e"
    },
    {
        "asset": "KARA",
        "gck_id": "karastar-umy"
    },
    {
        "asset": "DKK",
        "gck_id": "daikokuten-sama"
    },
    {
        "asset": "AST",
        "gck_id": "airswap"
    },
    {
        "asset": "AUTO",
        "gck_id": "auto"
    },
    {
        "asset": "BRWL",
        "gck_id": "blockchain-brawlers"
    },
    {
        "asset": "BSV",
        "gck_id": "bitcoin-cash-sv"
    },
    {
        "asset": "CAKE",
        "gck_id": "pancakeswap-token"
    },
    {
        "asset": "CHR",
        "gck_id": "chromaway"
    },
    {
        "asset": "CRPT",
        "gck_id": "crypterium"
    },
    {
        "asset": "CUDOS",
        "gck_id": "cudos"
    },
    {
        "asset": "ALPINE",
        "gck_id": "alpine-f1-team-fan-token"
    },
    {
        "asset": "AMB",
        "gck_id": "amber"
    },
    {
        "asset": "ANC",
        "gck_id": "anchor-protocol"
    },
    {
        "asset": "ANY",
        "gck_id": "anyswap"
    },
    {
        "asset": "AOA",
        "gck_id": "aurora"
    },
    {
        "asset": "AOG",
        "gck_id": "smartofgiving"
    },
    {
        "asset": "APL",
        "gck_id": "apollo"
    },
    {
        "asset": "APPC",
        "gck_id": "appcoins"
    },
    {
        "asset": "ARDR",
        "gck_id": "ardor"
    },
    {
        "asset": "ARK",
        "gck_id": "ark"
    },
    {
        "asset": "ARKER",
        "gck_id": "arker-2"
    },
    {
        "asset": "ARNM",
        "gck_id": "arenum"
    },
    {
        "asset": "ARRR",
        "gck_id": "pirate-chain"
    },
    {
        "asset": "ARX",
        "gck_id": "arcs"
    },
    {
        "asset": "ASTRA",
        "gck_id": "astra-protocol-2"
    },
    {
        "asset": "AUSD",
        "gck_id": "acala-dollar-karura"
    },
    {
        "asset": "AVA",
        "gck_id": "concierge-io"
    },
    {
        "asset": "AXPR",
        "gck_id": "axpire"
    },
    {
        "asset": "DIKO",
        "gck_id": "arkadiko-protocol"
    },
    {
        "asset": "DINO",
        "gck_id": "dinolfg"
    },
    {
        "asset": "DIVI",
        "gck_id": "divi"
    },
    {
        "asset": "DLT",
        "gck_id": "agrello"
    },
    {
        "asset": "DMTR",
        "gck_id": "dimitra"
    },
    {
        "asset": "DODO",
        "gck_id": "dodo"
    },
    {
        "asset": "DORA",
        "gck_id": "dora-factory"
    },
    {
        "asset": "DOSE",
        "gck_id": "dose-token"
    },
    {
        "asset": "DPET",
        "gck_id": "my-defi-pet"
    },
    {
        "asset": "DPI",
        "gck_id": "defipulse-index"
    },
    {
        "asset": "DPR",
        "gck_id": "deeper-network"
    },
    {
        "asset": "DPX",
        "gck_id": "dopex"
    },
    {
        "asset": "DREAMS",
        "gck_id": "dreams-quest"
    },
    {
        "asset": "DRGN",
        "gck_id": "dragonchain"
    },
    {
        "asset": "DSLA",
        "gck_id": "stacktical"
    },
    {
        "asset": "DUSK",
        "gck_id": "dusk-network"
    },
    {
        "asset": "DVPN",
        "gck_id": "sentinel"
    },
    {
        "asset": "DYDX",
        "gck_id": "dydx"
    },
    {
        "asset": "ECOX",
        "gck_id": "ecox"
    },
    {
        "asset": "EFI",
        "gck_id": "efinity"
    },
    {
        "asset": "EFX",
        "gck_id": "effect-network"
    },
    {
        "asset": "EGAME",
        "gck_id": "every-game"
    },
    {
        "asset": "ELF",
        "gck_id": "aelf"
    },
    {
        "asset": "ELON",
        "gck_id": "dogelon-mars"
    },
    {
        "asset": "ENG",
        "gck_id": "enigma"
    },
    {
        "asset": "ENQ",
        "gck_id": "enq-enecuum"
    },
    {
        "asset": "EOSC",
        "gck_id": "eosforce"
    },
    {
        "asset": "EPIK",
        "gck_id": "epik-prime"
    },
    {
        "asset": "EPK",
        "gck_id": "epik-protocol"
    },
    {
        "asset": "EPS",
        "gck_id": "ellipsis"
    },
    {
        "asset": "EPX",
        "gck_id": "ellipsis-x"
    },
    {
        "asset": "EQX",
        "gck_id": "eqifi"
    },
    {
        "asset": "EQZ",
        "gck_id": "equalizer"
    },
    {
        "asset": "ERG",
        "gck_id": "ergo"
    },
    {
        "asset": "ERSDL",
        "gck_id": "unfederalreserve"
    },
    {
        "asset": "ERTHA",
        "gck_id": "ertha"
    },
    {
        "asset": "ETC",
        "gck_id": "ethereum-classic"
    },
    {
        "asset": "ETH",
        "gck_id": "ethereum"
    },
    {
        "asset": "ETH2",
        "gck_id": "eth2-staking-by-poolx"
    },
    {
        "asset": "ETH3S",
        "gck_id": "eth3s"
    },
    {
        "asset": "ETHDOWN",
        "gck_id": "ethdown"
    },
    {
        "asset": "ETHO",
        "gck_id": "ether-1"
    },
    {
        "asset": "ETHUP",
        "gck_id": "ethup"
    },
    {
        "asset": "ETHW",
        "gck_id": "ethereum-pow-iou"
    },
    {
        "asset": "ETN",
        "gck_id": "electroneum"
    },
    {
        "asset": "EUL",
        "gck_id": "euler"
    },
    {
        "asset": "EVER",
        "gck_id": "everscale"
    },
    {
        "asset": "EVX",
        "gck_id": "everex"
    },
    {
        "asset": "EWT",
        "gck_id": "energy-web-token"
    },
    {
        "asset": "EXRD",
        "gck_id": "e-radix"
    },
    {
        "asset": "EZ",
        "gck_id": "easyfi"
    },
    {
        "asset": "ICX",
        "gck_id": "icon"
    },
    {
        "asset": "ID",
        "gck_id": "space-id"
    },
    {
        "asset": "IDEA",
        "gck_id": "ideaology"
    },
    {
        "asset": "IDRT",
        "gck_id": "rupiah-token"
    },
    {
        "asset": "IGU",
        "gck_id": "iguverse-igu"
    },
    {
        "asset": "IHC",
        "gck_id": "inflation-hedging-coin"
    },
    {
        "asset": "ILA",
        "gck_id": "infinite-launch"
    },
    {
        "asset": "INDI",
        "gck_id": "indigg"
    },
    {
        "asset": "INS",
        "gck_id": "inftspace"
    },
    {
        "asset": "IOI",
        "gck_id": "ioi-token"
    },
    {
        "asset": "IOST",
        "gck_id": "iostoken"
    },
    {
        "asset": "IQ",
        "gck_id": "everipedia"
    },
    {
        "asset": "IRIS",
        "gck_id": "iris-network"
    },
    {
        "asset": "ISP",
        "gck_id": "ispolink"
    },
    {
        "asset": "ITAMCUBE",
        "gck_id": "cube"
    },
    {
        "asset": "IXS",
        "gck_id": "ix-swap"
    },
    {
        "asset": "JAM",
        "gck_id": "geojam"
    },
    {
        "asset": "JAR",
        "gck_id": "jarvis"
    },
    {
        "asset": "JOE",
        "gck_id": "joe"
    },
    {
        "asset": "JST",
        "gck_id": "just"
    },
    {
        "asset": "JUV",
        "gck_id": "juventus-fan-token"
    },
    {
        "asset": "KAI",
        "gck_id": "kardiachain"
    },
    {
        "asset": "KAR",
        "gck_id": "karura"
    },
    {
        "asset": "KAT",
        "gck_id": "kambria"
    },
    {
        "asset": "KCS",
        "gck_id": "kucoin-shares"
    },
    {
        "asset": "LON",
        "gck_id": "tokenlon"
    },
    {
        "asset": "LOOKS",
        "gck_id": "looksrare"
    },
    {
        "asset": "LOVE",
        "gck_id": "deesse"
    },
    {
        "asset": "LPOOL",
        "gck_id": "launchpool"
    },
    {
        "asset": "LSK",
        "gck_id": "lisk"
    },
    {
        "asset": "LSS",
        "gck_id": "lossless"
    },
    {
        "asset": "LTO",
        "gck_id": "lto-network"
    },
    {
        "asset": "LTX",
        "gck_id": "lattice-token"
    },
    {
        "asset": "LUN",
        "gck_id": "lunyr"
    },
    {
        "asset": "MNST",
        "gck_id": "moonstarter"
    },
    {
        "asset": "MNW",
        "gck_id": "morpheus-network"
    },
    {
        "asset": "MOB",
        "gck_id": "mobilecoin"
    },
    {
        "asset": "MODEFI",
        "gck_id": "modefi"
    },
    {
        "asset": "MONI",
        "gck_id": "monsta-infinite"
    },
    {
        "asset": "MOOV",
        "gck_id": "dotmoovs"
    },
    {
        "asset": "MOVR",
        "gck_id": "moonriver"
    },
    {
        "asset": "MPLX",
        "gck_id": "metaplex"
    },
    {
        "asset": "CAPP",
        "gck_id": "cappasity"
    },
    {
        "asset": "CARE",
        "gck_id": "carecoin"
    },
    {
        "asset": "CARR",
        "gck_id": "carnomaly"
    },
    {
        "asset": "CAS",
        "gck_id": "cashaa"
    },
    {
        "asset": "CBC",
        "gck_id": "cashbet-coin"
    },
    {
        "asset": "CDT",
        "gck_id": "checkdot"
    },
    {
        "asset": "CEEK",
        "gck_id": "ceek"
    },
    {
        "asset": "CELT",
        "gck_id": "celestial"
    },
    {
        "asset": "CERE",
        "gck_id": "cere-network"
    },
    {
        "asset": "CFX",
        "gck_id": "conflux-token"
    },
    {
        "asset": "CGG",
        "gck_id": "chain-guardians"
    },
    {
        "asset": "CHMB",
        "gck_id": "chumbai-valley"
    },
    {
        "asset": "CHSB",
        "gck_id": "swissborg"
    },
    {
        "asset": "CIRUS",
        "gck_id": "cirus"
    },
    {
        "asset": "CIX100",
        "gck_id": "cryptoindex-io"
    },
    {
        "asset": "CKB",
        "gck_id": "nervos-network"
    },
    {
        "asset": "CMP",
        "gck_id": "caduceus"
    },
    {
        "asset": "CMT",
        "gck_id": "cybermiles"
    },
    {
        "asset": "CNH",
        "gck_id": "cnh-tether"
    },
    {
        "asset": "COCOS",
        "gck_id": "cocos-bcx"
    },
    {
        "asset": "COMB",
        "gck_id": "comb-finance"
    },
    {
        "asset": "COOHA",
        "gck_id": "coolmining"
    },
    {
        "asset": "COS",
        "gck_id": "contentos"
    },
    {
        "asset": "COVER",
        "gck_id": "cover-protocol"
    },
    {
        "asset": "CPC",
        "gck_id": "cryptoperformance-coin"
    },
    {
        "asset": "CPOOL",
        "gck_id": "clearpool"
    },
    {
        "asset": "CREAM",
        "gck_id": "cream-2"
    },
    {
        "asset": "CREDI",
        "gck_id": "credefi"
    },
    {
        "asset": "CSIX",
        "gck_id": "carbon-browser"
    },
    {
        "asset": "CSPR",
        "gck_id": "casper-network"
    },
    {
        "asset": "CTC",
        "gck_id": "creditcoin-2"
    },
    {
        "asset": "CTI",
        "gck_id": "clintex-cti"
    },
    {
        "asset": "CTXC",
        "gck_id": "cortex"
    },
    {
        "asset": "CULT",
        "gck_id": "cult-dao"
    },
    {
        "asset": "CV",
        "gck_id": "carvertical"
    },
    {
        "asset": "CVP",
        "gck_id": "concentrated-voting-power"
    },
    {
        "asset": "CWAR",
        "gck_id": "cryowar-token"
    },
    {
        "asset": "CWEB",
        "gck_id": "coinweb"
    },
    {
        "asset": "CWS",
        "gck_id": "crowns"
    },
    {
        "asset": "FORM",
        "gck_id": "formation-fi"
    },
    {
        "asset": "FRA",
        "gck_id": "findora"
    },
    {
        "asset": "FRM",
        "gck_id": "ferrum-network"
    },
    {
        "asset": "FRONT",
        "gck_id": "frontier-token"
    },
    {
        "asset": "FRR",
        "gck_id": "front-row"
    },
    {
        "asset": "FSN",
        "gck_id": "fsn&amp"
    },
    {
        "asset": "FT",
        "gck_id": "fracton-protocol"
    },
    {
        "asset": "FTG",
        "gck_id": "fantomgo"
    },
    {
        "asset": "FTM",
        "gck_id": "fantom"
    },
    {
        "asset": "FTT",
        "gck_id": "ftx-token"
    },
    {
        "asset": "FUEL",
        "gck_id": "etherparty"
    },
    {
        "asset": "FUN",
        "gck_id": "funfair"
    },
    {
        "asset": "FXS",
        "gck_id": "frax-share"
    },
    {
        "asset": "GAFI",
        "gck_id": "gamefi"
    },
    {
        "asset": "GARI",
        "gck_id": "gari-network"
    },
    {
        "asset": "GAS",
        "gck_id": "gas"
    },
    {
        "asset": "GEEQ",
        "gck_id": "geeq"
    },
    {
        "asset": "GEMIE",
        "gck_id": "gemie"
    },
    {
        "asset": "GENS",
        "gck_id": "genshiro"
    },
    {
        "asset": "HIPUNKS",
        "gck_id": "hipunks"
    },
    {
        "asset": "HIRENGA",
        "gck_id": "hirenga"
    },
    {
        "asset": "HISAND33",
        "gck_id": "hisand33"
    },
    {
        "asset": "HISEALS",
        "gck_id": "hiseals"
    },
    {
        "asset": "HISQUIGGLE",
        "gck_id": "hisquiggle"
    },
    {
        "asset": "HIUNDEAD",
        "gck_id": "hiundead"
    },
    {
        "asset": "HIVALHALLA",
        "gck_id": "hivalhalla"
    },
    {
        "asset": "HIVE",
        "gck_id": "hive"
    },
    {
        "asset": "HNT",
        "gck_id": "helium"
    },
    {
        "asset": "HOOK",
        "gck_id": "hooked-protocol"
    },
    {
        "asset": "HORD",
        "gck_id": "hord"
    },
    {
        "asset": "HOT",
        "gck_id": "holotoken"
    },
    {
        "asset": "HOTCROSS",
        "gck_id": "hot-cross"
    },
    {
        "asset": "HT",
        "gck_id": "huobi-token"
    },
    {
        "asset": "HTR",
        "gck_id": "hathor"
    },
    {
        "asset": "HYDRA",
        "gck_id": "hydra"
    },
    {
        "asset": "HYVE",
        "gck_id": "hyve"
    },
    {
        "asset": "MARS4",
        "gck_id": "mars4"
    },
    {
        "asset": "MARSH",
        "gck_id": "unmarshal"
    },
    {
        "asset": "MASK",
        "gck_id": "mask-network"
    },
    {
        "asset": "MATCH",
        "gck_id": "matchcup"
    },
    {
        "asset": "MATIC",
        "gck_id": "matic-network"
    },
    {
        "asset": "MATTER",
        "gck_id": "antimatter"
    },
    {
        "asset": "MBL",
        "gck_id": "moviebloc"
    },
    {
        "asset": "MBOX",
        "gck_id": "mobox"
    },
    {
        "asset": "MC",
        "gck_id": "merit-circle"
    },
    {
        "asset": "MCO",
        "gck_id": "monaco"
    },
    {
        "asset": "MCV",
        "gck_id": "mcverse"
    },
    {
        "asset": "MDA",
        "gck_id": "moeda-loyalty-points"
    },
    {
        "asset": "MDX",
        "gck_id": "mdex"
    },
    {
        "asset": "MELOS",
        "gck_id": "melos-studio"
    },
    {
        "asset": "MEM",
        "gck_id": "memecoin"
    },
    {
        "asset": "MFT",
        "gck_id": "mainframe"
    },
    {
        "asset": "MHC",
        "gck_id": "metahash"
    },
    {
        "asset": "MIA",
        "gck_id": "miamicoin"
    },
    {
        "asset": "MIM",
        "gck_id": "magic-internet-money"
    },
    {
        "asset": "MITH",
        "gck_id": "mithril"
    },
    {
        "asset": "MITX",
        "gck_id": "morpheus-labs"
    },
    {
        "asset": "MJT",
        "gck_id": "mojitoswap"
    },
    {
        "asset": "MLK",
        "gck_id": "milk-alliance"
    },
    {
        "asset": "MLS",
        "gck_id": "pikaster"
    },
    {
        "asset": "MNET",
        "gck_id": "mine-network"
    },
    {
        "asset": "PRMX",
        "gck_id": "prema"
    },
    {
        "asset": "PROM",
        "gck_id": "prometeus"
    },
    {
        "asset": "PROS",
        "gck_id": "prosper"
    },
    {
        "asset": "PSG",
        "gck_id": "paris-saint-germain-fan-token"
    },
    {
        "asset": "PSL",
        "gck_id": "pastel"
    },
    {
        "asset": "PSTAKE",
        "gck_id": "pstake-finance"
    },
    {
        "asset": "PUMLX",
        "gck_id": "pumlx"
    },
    {
        "asset": "PUSH",
        "gck_id": "ethereum-push-notification-service"
    },
    {
        "asset": "QKC",
        "gck_id": "quark-chain"
    },
    {
        "asset": "QLC",
        "gck_id": "qlink"
    },
    {
        "asset": "QRDO",
        "gck_id": "qredo"
    },
    {
        "asset": "QUARTZ",
        "gck_id": "sandclock"
    },
    {
        "asset": "RACA",
        "gck_id": "radio-caca"
    },
    {
        "asset": "RACEFI",
        "gck_id": "racefi"
    },
    {
        "asset": "RAMP",
        "gck_id": "ramp"
    },
    {
        "asset": "RANKER",
        "gck_id": "rankerdao"
    },
    {
        "asset": "RBP",
        "gck_id": "rare-ball-shares"
    },
    {
        "asset": "RBTC",
        "gck_id": "rootstock"
    },
    {
        "asset": "RCN",
        "gck_id": "ripio-credit-network"
    },
    {
        "asset": "RDN",
        "gck_id": "raiden-network"
    },
    {
        "asset": "TRIAS",
        "gck_id": "trias-token"
    },
    {
        "asset": "TRIBE",
        "gck_id": "tribe-2"
    },
    {
        "asset": "TRIBL",
        "gck_id": "tribal-token"
    },
    {
        "asset": "TRVL",
        "gck_id": "dtravel"
    },
    {
        "asset": "TRX",
        "gck_id": "tron"
    },
    {
        "asset": "TRY",
        "gck_id": "tryhards"
    },
    {
        "asset": "TT",
        "gck_id": "thunder-token"
    },
    {
        "asset": "TULIP",
        "gck_id": "solfarm"
    },
    {
        "asset": "TUSD",
        "gck_id": "true-usd"
    },
    {
        "asset": "TWT",
        "gck_id": "trust-wallet-token"
    },
    {
        "asset": "TXA",
        "gck_id": "txa"
    },
    {
        "asset": "UAH",
        "gck_id": "chihuahua-token"
    },
    {
        "asset": "UBX",
        "gck_id": "ubix-network"
    },
    {
        "asset": "UDOO",
        "gck_id": "howdoo"
    },
    {
        "asset": "UFO",
        "gck_id": "ufo-gaming"
    },
    {
        "asset": "UFT",
        "gck_id": "unlend-finance"
    },
    {
        "asset": "UMB",
        "gck_id": "umbrella-network"
    },
    {
        "asset": "UNB",
        "gck_id": "unbound-finance"
    },
    {
        "asset": "UNIC",
        "gck_id": "unicly"
    },
    {
        "asset": "UNO",
        "gck_id": "nostra-uno"
    },
    {
        "asset": "UOS",
        "gck_id": "ultra"
    },
    {
        "asset": "UPO",
        "gck_id": "uponly-token"
    },
    {
        "asset": "UQC",
        "gck_id": "uquid-coin"
    },
    {
        "asset": "URUS",
        "gck_id": "urus-token"
    },
    {
        "asset": "WSIENNA",
        "gck_id": "sienna-erc20"
    },
    {
        "asset": "WTC",
        "gck_id": "waltonchain"
    },
    {
        "asset": "WXT",
        "gck_id": "wirex"
    },
    {
        "asset": "XAVA",
        "gck_id": "avalaunch"
    },
    {
        "asset": "XBTC",
        "gck_id": "wrapped-xbtc"
    },
    {
        "asset": "XCAD",
        "gck_id": "xcad-network"
    },
    {
        "asset": "XCH",
        "gck_id": "chia"
    },
    {
        "asset": "XCUR",
        "gck_id": "curate"
    },
    {
        "asset": "XCV",
        "gck_id": "xcarnival"
    },
    {
        "asset": "XDB",
        "gck_id": "digitalbits"
    },
    {
        "asset": "XDC",
        "gck_id": "xdce-crowd-sale"
    },
    {
        "asset": "XDEFI",
        "gck_id": "xdefi"
    },
    {
        "asset": "XEC",
        "gck_id": "ecash"
    },
    {
        "asset": "XED",
        "gck_id": "exeedme"
    },
    {
        "asset": "XEM",
        "gck_id": "nem"
    },
    {
        "asset": "XETA",
        "gck_id": "xana"
    },
    {
        "asset": "XHV",
        "gck_id": "haven"
    },
    {
        "asset": "XLMDOWN",
        "gck_id": "meltdown-battle-for-the-safezone"
    },
    {
        "asset": "XMR",
        "gck_id": "monero"
    },
    {
        "asset": "XNL",
        "gck_id": "chronicle"
    },
    {
        "asset": "XPR",
        "gck_id": "proton"
    },
    {
        "asset": "XPRT",
        "gck_id": "persistence"
    },
    {
        "asset": "XRD",
        "gck_id": "radix"
    },
    {
        "asset": "XSR",
        "gck_id": "sucrecoin"
    },
    {
        "asset": "XTAG",
        "gck_id": "xhashtag"
    },
    {
        "asset": "XTM",
        "gck_id": "torum"
    },
    {
        "asset": "XVG",
        "gck_id": "verge"
    },
    {
        "asset": "XVS",
        "gck_id": "venus"
    },
    {
        "asset": "XWG",
        "gck_id": "x-world-games"
    },
    {
        "asset": "XYM",
        "gck_id": "symbol"
    },
    {
        "asset": "YFDAI",
        "gck_id": "yfdai-finance"
    },
    {
        "asset": "YGG",
        "gck_id": "yield-guild-games"
    },
    {
        "asset": "YLD",
        "gck_id": "yield-app"
    },
    {
        "asset": "YOP",
        "gck_id": "yield-optimization-platform"
    },
    {
        "asset": "YOYOW",
        "gck_id": "yoyow"
    },
    {
        "asset": "ZAR",
        "gck_id": "zarcash"
    },
    {
        "asset": "ZBC",
        "gck_id": "zebec-protocol"
    },
    {
        "asset": "ZCX",
        "gck_id": "unizen"
    },
    {
        "asset": "ZEE",
        "gck_id": "zeroswap"
    },
    {
        "asset": "ZKT",
        "gck_id": "zktsunami"
    },
    {
        "asset": "USD",
        "gck_id": "usd"
    },
    {
        "asset": "USDC",
        "gck_id": "usd-coin"
    },
    {
        "asset": "USDJ",
        "gck_id": "just-stablecoin"
    },
    {
        "asset": "USDK",
        "gck_id": "usdk"
    },
    {
        "asset": "USDS",
        "gck_id": "stableusd"
    },
    {
        "asset": "USDT_ERC20",
        "gck_id": "tether"
    },
    {
        "asset": "UTK",
        "gck_id": "utrust"
    },
    {
        "asset": "VAI",
        "gck_id": "vai"
    },
    {
        "asset": "VAIOT",
        "gck_id": "vaiot"
    },
    {
        "asset": "VEED",
        "gck_id": "veed"
    },
    {
        "asset": "VEGA",
        "gck_id": "vega-protocol"
    },
    {
        "asset": "VELO",
        "gck_id": "velo"
    },
    {
        "asset": "VEMP",
        "gck_id": "vempire-ddao"
    },
    {
        "asset": "VET",
        "gck_id": "vechain"
    },
    {
        "asset": "VIA",
        "gck_id": "viacoin"
    },
    {
        "asset": "VIB",
        "gck_id": "viberate"
    },
    {
        "asset": "VIBE",
        "gck_id": "vibe"
    },
    {
        "asset": "VID",
        "gck_id": "videocoin"
    },
    {
        "asset": "VIDT",
        "gck_id": "vidt-dao"
    },
    {
        "asset": "VISION",
        "gck_id": "visiongame"
    },
    {
        "asset": "VITE",
        "gck_id": "vite"
    },
    {
        "asset": "VLX",
        "gck_id": "velas"
    },
    {
        "asset": "VR",
        "gck_id": "victoria-vr"
    },
    {
        "asset": "VRA",
        "gck_id": "verasity"
    },
    {
        "asset": "VSYS",
        "gck_id": "v-systems"
    },
    {
        "asset": "VTHO",
        "gck_id": "vethor-token"
    },
    {
        "asset": "VXV",
        "gck_id": "vectorspace"
    },
    {
        "asset": "WAL",
        "gck_id": "the-wasted-lands"
    },
    {
        "asset": "WAN",
        "gck_id": "wanchain"
    },
    {
        "asset": "WAVES",
        "gck_id": "waves"
    },
    {
        "asset": "WELL",
        "gck_id": "moonwell-artemis"
    },
    {
        "asset": "WEMIX",
        "gck_id": "wemix-token"
    },
    {
        "asset": "WEST",
        "gck_id": "waves-enterprise"
    },
    {
        "asset": "WHALE",
        "gck_id": "whale"
    },
    {
        "asset": "WILD",
        "gck_id": "wilder-world"
    },
    {
        "asset": "WIN",
        "gck_id": "wink"
    },
    {
        "asset": "WNCG",
        "gck_id": "wrapped-ncg"
    },
    {
        "asset": "WNXM",
        "gck_id": "wrapped-nxm"
    },
    {
        "asset": "WOM",
        "gck_id": "wombat-exchange"
    },
    {
        "asset": "WOMBAT",
        "gck_id": "wombat"
    },
    {
        "asset": "WOO",
        "gck_id": "woo-network"
    },
    {
        "asset": "WOOP",
        "gck_id": "woonkly-power"
    },
    {
        "asset": "WPR",
        "gck_id": "wepower"
    },
    {
        "asset": "WRX",
        "gck_id": "wazirx"
    },
    {
        "asset": "RDNT",
        "gck_id": "radiant-capital"
    },
    {
        "asset": "REAP",
        "gck_id": "reapchain"
    },
    {
        "asset": "RED",
        "gck_id": "red-token"
    },
    {
        "asset": "REEF",
        "gck_id": "reef"
    },
    {
        "asset": "REI",
        "gck_id": "rei-network"
    },
    {
        "asset": "RENBTC",
        "gck_id": "renbtc"
    },
    {
        "asset": "REV",
        "gck_id": "revain"
    },
    {
        "asset": "REV3L",
        "gck_id": "rev3al"
    },
    {
        "asset": "REVU",
        "gck_id": "revuto"
    },
    {
        "asset": "REVV",
        "gck_id": "revv"
    },
    {
        "asset": "RFUEL",
        "gck_id": "rio-defi"
    },
    {
        "asset": "RGT",
        "gck_id": "rari-governance-token"
    },
    {
        "asset": "RIF",
        "gck_id": "rif-token"
    },
    {
        "asset": "RMRK",
        "gck_id": "rmrk"
    },
    {
        "asset": "ROAR",
        "gck_id": "alpha-dex"
    },
    {
        "asset": "RON",
        "gck_id": "ronin"
    },
    {
        "asset": "ROOBEE",
        "gck_id": "roobee"
    },
    {
        "asset": "ROSN",
        "gck_id": "roseon-finance"
    },
    {
        "asset": "ROUTE",
        "gck_id": "route"
    },
    {
        "asset": "SHX",
        "gck_id": "stronghold-token"
    },
    {
        "asset": "SIDUS",
        "gck_id": "sidus"
    },
    {
        "asset": "SIMP",
        "gck_id": "socol"
    },
    {
        "asset": "SIN",
        "gck_id": "sin-city"
    },
    {
        "asset": "SKEY",
        "gck_id": "skey-network"
    },
    {
        "asset": "SKU",
        "gck_id": "sakura"
    },
    {
        "asset": "SKY",
        "gck_id": "skycoin"
    },
    {
        "asset": "SLCL",
        "gck_id": "solcial"
    },
    {
        "asset": "SLIM",
        "gck_id": "solanium"
    },
    {
        "asset": "SLP",
        "gck_id": "smooth-love-potion"
    },
    {
        "asset": "SNGLS",
        "gck_id": "singulardtv"
    },
    {
        "asset": "SNTVT",
        "gck_id": "sentivate"
    },
    {
        "asset": "SOLR",
        "gck_id": "solrazr"
    },
    {
        "asset": "SOLVE",
        "gck_id": "solve-care"
    },
    {
        "asset": "SON",
        "gck_id": "souni-token"
    },
    {
        "asset": "SOS",
        "gck_id": "opendao"
    },
    {
        "asset": "SOUL",
        "gck_id": "phantasma"
    },
    {
        "asset": "SOV",
        "gck_id": "sovryn"
    },
    {
        "asset": "SPA",
        "gck_id": "sperax"
    },
    {
        "asset": "SPARTA",
        "gck_id": "spartan-protocol-token"
    },
    {
        "asset": "SQUAD",
        "gck_id": "squad"
    },
    {
        "asset": "SRBP",
        "gck_id": "super-rare-ball-shares"
    },
    {
        "asset": "SRK",
        "gck_id": "sparkpoint"
    },
    {
        "asset": "SRM",
        "gck_id": "serum"
    },
    {
        "asset": "SSV",
        "gck_id": "ssv-network"
    },
    {
        "asset": "STARLY",
        "gck_id": "starly"
    },
    {
        "asset": "STC",
        "gck_id": "student-coin"
    },
    {
        "asset": "STEEM",
        "gck_id": "steem"
    },
    {
        "asset": "STEPWATCH",
        "gck_id": "stepwatch"
    },
    {
        "asset": "STETH",
        "gck_id": "staked-ether"
    },
    {
        "asset": "STG",
        "gck_id": "stargate-finance"
    },
    {
        "asset": "STMX",
        "gck_id": "storm"
    },
    {
        "asset": "STND",
        "gck_id": "standard-protocol"
    },
    {
        "asset": "STORE",
        "gck_id": "bit-store-coin"
    },
    {
        "asset": "STPT",
        "gck_id": "stp-network"
    },
    {
        "asset": "STRAX",
        "gck_id": "stratis"
    },
    {
        "asset": "STRK",
        "gck_id": "strike"
    },
    {
        "asset": "STRONG",
        "gck_id": "strong"
    },
    {
        "asset": "SUN",
        "gck_id": "sun-token"
    },
    {
        "asset": "SURV",
        "gck_id": "survivor"
    },
    {
        "asset": "SUSD",
        "gck_id": "nusd"
    },
    {
        "asset": "SUSHIUP",
        "gck_id": "sushiswap"
    },
    {
        "asset": "SUTER",
        "gck_id": "suterusu"
    },
    {
        "asset": "SWASH",
        "gck_id": "swash"
    },
    {
        "asset": "SWEAT",
        "gck_id": "sweatcoin"
    },
    {
        "asset": "SWINGBY",
        "gck_id": "swingby"
    },
    {
        "asset": "SWP",
        "gck_id": "kava-swap"
    },
    {
        "asset": "SWRV",
        "gck_id": "swerve-dao"
    },
    {
        "asset": "SYN",
        "gck_id": "synapse-2"
    },
    {
        "asset": "SYNR",
        "gck_id": "syndicate-2"
    },
    {
        "asset": "SYS",
        "gck_id": "syscoin"
    },
    {
        "asset": "T",
        "gck_id": "threshold-network-token"
    },
    {
        "asset": "TARA",
        "gck_id": "taraxa"
    },
    {
        "asset": "TAUM",
        "gck_id": "orbitau-taureum"
    },
    {
        "asset": "TCP",
        "gck_id": "the-crypto-prophecies"
    },
    {
        "asset": "TCT",
        "gck_id": "tokenclub"
    },
    {
        "asset": "TEL",
        "gck_id": "telcoin"
    },
    {
        "asset": "TEM",
        "gck_id": "temdao"
    },
    {
        "asset": "TFUEL",
        "gck_id": "theta-fuel"
    },
    {
        "asset": "THETA",
        "gck_id": "theta-token"
    },
    {
        "asset": "TIDAL",
        "gck_id": "tidal-finance"
    },
    {
        "asset": "TITAN",
        "gck_id": "titanswap"
    },
    {
        "asset": "TKO",
        "gck_id": "tokocrypto"
    },
    {
        "asset": "TLM",
        "gck_id": "alien-worlds"
    },
    {
        "asset": "TLOS",
        "gck_id": "telos"
    },
    {
        "asset": "TNB",
        "gck_id": "time-new-bank"
    },
    {
        "asset": "TNT",
        "gck_id": "talent"
    },
    {
        "asset": "TOKO",
        "gck_id": "toko"
    },
    {
        "asset": "TOMO",
        "gck_id": "tomochain"
    },
    {
        "asset": "TON",
        "gck_id": "the-open-network"
    },
    {
        "asset": "TORN",
        "gck_id": "tornado-cash"
    },
    {
        "asset": "TOWER",
        "gck_id": "tower"
    },
    {
        "asset": "RPC",
        "gck_id": "republic-credits"
    },
    {
        "asset": "RSR",
        "gck_id": "reserve-rights-token"
    },
    {
        "asset": "RVN",
        "gck_id": "ravencoin"
    },
    {
        "asset": "SANTOS",
        "gck_id": "santos-fc-fan-token"
    },
    {
        "asset": "SC",
        "gck_id": "siacoin"
    },
    {
        "asset": "SCLP",
        "gck_id": "scallop"
    },
    {
        "asset": "SCRT",
        "gck_id": "secret"
    },
    {
        "asset": "SDAO",
        "gck_id": "singularitydao"
    },
    {
        "asset": "SDL",
        "gck_id": "saddle-finance"
    },
    {
        "asset": "SDN",
        "gck_id": "wrapped-shiden-network"
    },
    {
        "asset": "SEK",
        "gck_id": "sekuritance"
    },
    {
        "asset": "SENSO",
        "gck_id": "senso"
    },
    {
        "asset": "SFP",
        "gck_id": "safepal"
    },
    {
        "asset": "SFUND",
        "gck_id": "seedify-fund"
    },
    {
        "asset": "SHA",
        "gck_id": "safe-haven"
    },
    {
        "asset": "SHFT",
        "gck_id": "shyft-network-2"
    },
    {
        "asset": "SHILL",
        "gck_id": "shill-token"
    },
    {
        "asset": "SHR",
        "gck_id": "sharering"
    },
    {
        "asset": "NRFB",
        "gck_id": "nurifootball"
    },
    {
        "asset": "NRG",
        "gck_id": "energi"
    },
    {
        "asset": "NTVRK",
        "gck_id": "netvrk"
    },
    {
        "asset": "NU",
        "gck_id": "nucypher"
    },
    {
        "asset": "NUM",
        "gck_id": "numbers-protocol"
    },
    {
        "asset": "NWC",
        "gck_id": "newscrypto-coin"
    },
    {
        "asset": "NXRA",
        "gck_id": "allianceblock-nexera"
    },
    {
        "asset": "NXS",
        "gck_id": "nexus"
    },
    {
        "asset": "NYM",
        "gck_id": "nym"
    },
    {
        "asset": "OAS",
        "gck_id": "oasys"
    },
    {
        "asset": "OAX",
        "gck_id": "openanx"
    },
    {
        "asset": "ODDZ",
        "gck_id": "oddz"
    },
    {
        "asset": "OG",
        "gck_id": "og-fan-token"
    },
    {
        "asset": "OGV",
        "gck_id": "origin-dollar-governance"
    },
    {
        "asset": "OLE",
        "gck_id": "openleverage"
    },
    {
        "asset": "OLT",
        "gck_id": "one-ledger"
    },
    {
        "asset": "OM",
        "gck_id": "mantra-dao"
    },
    {
        "asset": "ONG",
        "gck_id": "ong"
    },
    {
        "asset": "ONSTON",
        "gck_id": "onston"
    },
    {
        "asset": "ONT",
        "gck_id": "ontology"
    },
    {
        "asset": "OOE",
        "gck_id": "openocean"
    },
    {
        "asset": "OPCT",
        "gck_id": "opacity"
    },
    {
        "asset": "OPUL",
        "gck_id": "opulous"
    },
    {
        "asset": "ORAI",
        "gck_id": "oraichain-token"
    },
    {
        "asset": "ORBS",
        "gck_id": "orbs"
    },
    {
        "asset": "ORC",
        "gck_id": "orbit-chain"
    },
    {
        "asset": "OSMO",
        "gck_id": "osmosis"
    },
    {
        "asset": "OST",
        "gck_id": "simple-token"
    },
    {
        "asset": "OUSD",
        "gck_id": "origin-dollar"
    },
    {
        "asset": "OVR",
        "gck_id": "ovr"
    },
    {
        "asset": "OXEN",
        "gck_id": "loki-network"
    },
    {
        "asset": "PAXG",
        "gck_id": "pax-gold"
    },
    {
        "asset": "PBR",
        "gck_id": "polkabridge"
    },
    {
        "asset": "PBX",
        "gck_id": "paribus"
    },
    {
        "asset": "PCX",
        "gck_id": "chainx"
    },
    {
        "asset": "PDEX",
        "gck_id": "polkadex"
    },
    {
        "asset": "PEEL",
        "gck_id": "meta-apes-peel"
    },
    {
        "asset": "PEL",
        "gck_id": "propel-token"
    },
    {
        "asset": "PEOPLE",
        "gck_id": "constitutiondao"
    },
    {
        "asset": "PERL",
        "gck_id": "perlin"
    },
    {
        "asset": "PGAL",
        "gck_id": "pgala"
    },
    {
        "asset": "PHA",
        "gck_id": "pha"
    },
    {
        "asset": "PHB",
        "gck_id": "phoenix-global"
    },
    {
        "asset": "PHNX",
        "gck_id": "phoenixdao"
    },
    {
        "asset": "PHX",
        "gck_id": "phoenix-token"
    },
    {
        "asset": "PIAS",
        "gck_id": "pias"
    },
    {
        "asset": "PIVX",
        "gck_id": "pivx"
    },
    {
        "asset": "PIX",
        "gck_id": "pixie"
    },
    {
        "asset": "PKF",
        "gck_id": "polkafoundry"
    },
    {
        "asset": "PLATO",
        "gck_id": "platon-network"
    },
    {
        "asset": "PLAY",
        "gck_id": "herocoin"
    },
    {
        "asset": "PLD",
        "gck_id": "plutonian-dao"
    },
    {
        "asset": "PLGR",
        "gck_id": "pledge"
    },
    {
        "asset": "PLN",
        "gck_id": "pollen"
    },
    {
        "asset": "PLY",
        "gck_id": "aurigami"
    },
    {
        "asset": "PMON",
        "gck_id": "polychain-monsters"
    },
    {
        "asset": "PNT",
        "gck_id": "pnetwork"
    },
    {
        "asset": "POA",
        "gck_id": "poa-network"
    },
    {
        "asset": "POE",
        "gck_id": "poet"
    },
    {
        "asset": "POKT",
        "gck_id": "pocket-network"
    },
    {
        "asset": "POL",
        "gck_id": "polars"
    },
    {
        "asset": "POLC",
        "gck_id": "polka-city"
    },
    {
        "asset": "POLK",
        "gck_id": "polkamarkets"
    },
    {
        "asset": "POLX",
        "gck_id": "polylastic"
    },
    {
        "asset": "MSWAP",
        "gck_id": "moneyswap"
    },
    {
        "asset": "MTH",
        "gck_id": "monetha"
    },
    {
        "asset": "MTRG",
        "gck_id": "meter"
    },
    {
        "asset": "MTS",
        "gck_id": "metis"
    },
    {
        "asset": "MTV",
        "gck_id": "multivac"
    },
    {
        "asset": "MULTI",
        "gck_id": "multichain"
    },
    {
        "asset": "MV",
        "gck_id": "gensokishis-metaverse"
    },
    {
        "asset": "MVP",
        "gck_id": "mvpad"
    },
    {
        "asset": "MXN",
        "gck_id": "mexican-peso-tether"
    },
    {
        "asset": "NAKA",
        "gck_id": "nakamoto-games"
    },
    {
        "asset": "NANO",
        "gck_id": "nano"
    },
    {
        "asset": "NAS",
        "gck_id": "nebulas"
    },
    {
        "asset": "NAV",
        "gck_id": "nav-coin"
    },
    {
        "asset": "NAVI",
        "gck_id": "natus-vincere-fan-token"
    },
    {
        "asset": "NBS",
        "gck_id": "new-bitshares"
    },
    {
        "asset": "NBT",
        "gck_id": "nanobyte"
    },
    {
        "asset": "NCASH",
        "gck_id": "nucleus-vision"
    },
    {
        "asset": "NDAU",
        "gck_id": "ndau"
    },
    {
        "asset": "NEBL",
        "gck_id": "neblio"
    },
    {
        "asset": "KEEP",
        "gck_id": "keep-network"
    },
    {
        "asset": "KEY",
        "gck_id": "selfkey"
    },
    {
        "asset": "KICKS",
        "gck_id": "getkicks"
    },
    {
        "asset": "KIN",
        "gck_id": "kin"
    },
    {
        "asset": "KING",
        "gck_id": "kingdomverse"
    },
    {
        "asset": "KLAY",
        "gck_id": "klay-token"
    },
    {
        "asset": "KLV",
        "gck_id": "klever"
    },
    {
        "asset": "KMA",
        "gck_id": "calamari-network"
    },
    {
        "asset": "KMD",
        "gck_id": "komodo"
    },
    {
        "asset": "KOK",
        "gck_id": "kok"
    },
    {
        "asset": "KOL",
        "gck_id": "kollect"
    },
    {
        "asset": "KONO",
        "gck_id": "konomi-network"
    },
    {
        "asset": "KP3R",
        "gck_id": "keep3rv1"
    },
    {
        "asset": "KYL",
        "gck_id": "kylin-network"
    },
    {
        "asset": "LABS",
        "gck_id": "labs-protocol"
    },
    {
        "asset": "LACE",
        "gck_id": "lovelace-world"
    },
    {
        "asset": "LAVAX",
        "gck_id": "lavax-labs"
    },
    {
        "asset": "LAYER",
        "gck_id": "unilayer"
    },
    {
        "asset": "LAZIO",
        "gck_id": "lazio-fan-token"
    },
    {
        "asset": "LBP",
        "gck_id": "launchblock"
    },
    {
        "asset": "LEND",
        "gck_id": "ethlend"
    },
    {
        "asset": "LEVER",
        "gck_id": "lever"
    },
    {
        "asset": "LIKE",
        "gck_id": "likecoin"
    },
    {
        "asset": "LITH",
        "gck_id": "lithium-finance"
    },
    {
        "asset": "LMR",
        "gck_id": "lumerin"
    },
    {
        "asset": "LOC",
        "gck_id": "lockchain"
    },
    {
        "asset": "LOCG",
        "gck_id": "locgame"
    },
    {
        "asset": "GFT",
        "gck_id": "gifto"
    },
    {
        "asset": "GGG",
        "gck_id": "good-games-guild"
    },
    {
        "asset": "GHX",
        "gck_id": "gamercoin"
    },
    {
        "asset": "GLCH",
        "gck_id": "glitch-protocol"
    },
    {
        "asset": "GLMR",
        "gck_id": "moonbeam"
    },
    {
        "asset": "GLQ",
        "gck_id": "graphlinq-protocol"
    },
    {
        "asset": "GMB",
        "gck_id": "gamb"
    },
    {
        "asset": "GMEE",
        "gck_id": "gamee"
    },
    {
        "asset": "GMM",
        "gck_id": "gamium"
    },
    {
        "asset": "GMX",
        "gck_id": "gmx"
    },
    {
        "asset": "GNS",
        "gck_id": "gains-network"
    },
    {
        "asset": "GNT",
        "gck_id": "greentrust"
    },
    {
        "asset": "GO",
        "gck_id": "gochain"
    },
    {
        "asset": "GOAL",
        "gck_id": "topgoal"
    },
    {
        "asset": "GOM2",
        "gck_id": "gomoney2"
    },
    {
        "asset": "GOVI",
        "gck_id": "govi"
    },
    {
        "asset": "GRAIL",
        "gck_id": "camelot-token"
    },
    {
        "asset": "GRIN",
        "gck_id": "grin"
    },
    {
        "asset": "GRS",
        "gck_id": "groestlcoin"
    },
    {
        "asset": "GTO",
        "gck_id": "gton-capital"
    },
    {
        "asset": "GVT",
        "gck_id": "genesis-vision"
    },
    {
        "asset": "GXC",
        "gck_id": "gxchain"
    },
    {
        "asset": "H2O",
        "gck_id": "h2o-dao"
    },
    {
        "asset": "H3RO3S",
        "gck_id": "h3ro3s"
    },
    {
        "asset": "HAI",
        "gck_id": "hackenai"
    },
    {
        "asset": "HAKA",
        "gck_id": "tribeone"
    },
    {
        "asset": "HALO",
        "gck_id": "halo-coin"
    },
    {
        "asset": "HAPI",
        "gck_id": "hapi"
    },
    {
        "asset": "HARD",
        "gck_id": "kava-lend"
    },
    {
        "asset": "HASH",
        "gck_id": "hashcoin"
    },
    {
        "asset": "HAWK",
        "gck_id": "hawksight"
    },
    {
        "asset": "HBB",
        "gck_id": "hubble"
    },
    {
        "asset": "HC",
        "gck_id": "hshare"
    },
    {
        "asset": "HEART",
        "gck_id": "humans-ai"
    },
    {
        "asset": "HEGIC",
        "gck_id": "hegic"
    },
    {
        "asset": "HERO",
        "gck_id": "metahero"
    },
    {
        "asset": "HIAZUKI",
        "gck_id": "hiazuki"
    },
    {
        "asset": "HIBAYC",
        "gck_id": "hibayc"
    },
    {
        "asset": "HIBEANZ",
        "gck_id": "hibeanz"
    },
    {
        "asset": "HICLONEX",
        "gck_id": "hiclonex"
    },
    {
        "asset": "HICOOLCATS",
        "gck_id": "hicoolcats"
    },
    {
        "asset": "HIDOODLES",
        "gck_id": "hidoodles"
    },
    {
        "asset": "HIENS3",
        "gck_id": "hiens3"
    },
    {
        "asset": "HIENS4",
        "gck_id": "hiens4"
    },
    {
        "asset": "HIFI",
        "gck_id": "hifi-finance"
    },
    {
        "asset": "HIFIDENZA",
        "gck_id": "hifidenza"
    },
    {
        "asset": "HIFLUF",
        "gck_id": "hifluf"
    },
    {
        "asset": "HIFRIENDS",
        "gck_id": "hifriends"
    },
    {
        "asset": "HIGAZERS",
        "gck_id": "higazers"
    },
    {
        "asset": "HIMAYC",
        "gck_id": "himayc"
    },
    {
        "asset": "HIMFERS",
        "gck_id": "himfers"
    },
    {
        "asset": "HIOD",
        "gck_id": "hiod"
    },
    {
        "asset": "HIODBS",
        "gck_id": "hiodbs"
    },
    {
        "asset": "HIPENGUINS",
        "gck_id": "hipenguins"
    },
    {
        "asset": "FALCONS",
        "gck_id": "falcon-swaps"
    },
    {
        "asset": "FCL",
        "gck_id": "fractal"
    },
    {
        "asset": "FCON",
        "gck_id": "spacefalcon"
    },
    {
        "asset": "FEAR",
        "gck_id": "fear"
    },
    {
        "asset": "FIO",
        "gck_id": "fio-protocol"
    },
    {
        "asset": "FIRO",
        "gck_id": "zcoin"
    },
    {
        "asset": "FITFI",
        "gck_id": "step-app-fitfi"
    },
    {
        "asset": "FKX",
        "gck_id": "fortknoxter"
    },
    {
        "asset": "FLAME",
        "gck_id": "firestarter"
    },
    {
        "asset": "FLM",
        "gck_id": "flamingo-finance"
    },
    {
        "asset": "FLOKI",
        "gck_id": "floki"
    },
    {
        "asset": "FLR",
        "gck_id": "flare-networks"
    },
    {
        "asset": "FLY",
        "gck_id": "franklin"
    },
    {
        "asset": "FOR",
        "gck_id": "force-protocol"
    },
    {
        "asset": "FORESTPLUS",
        "gck_id": "the-forbidden-forest"
    },
    {
        "asset": "DAG",
        "gck_id": "constellation-labs"
    },
    {
        "asset": "DAPPT",
        "gck_id": "dapp-com"
    },
    {
        "asset": "DAPPX",
        "gck_id": "dappstore"
    },
    {
        "asset": "DCR",
        "gck_id": "decred"
    },
    {
        "asset": "DEGO",
        "gck_id": "dego-finance"
    },
    {
        "asset": "DERC",
        "gck_id": "derace"
    },
    {
        "asset": "DERO",
        "gck_id": "dero"
    },
    {
        "asset": "DEXE",
        "gck_id": "dexe"
    },
    {
        "asset": "DF",
        "gck_id": "dforce-token"
    },
    {
        "asset": "DFA",
        "gck_id": "define"
    },
    {
        "asset": "DFI",
        "gck_id": "defichain"
    },
    {
        "asset": "DFYN",
        "gck_id": "dfyn-network"
    },
    {
        "asset": "DG",
        "gck_id": "degate"
    },
    {
        "asset": "DGD",
        "gck_id": "digixdao"
    },
    {
        "asset": "DGTX",
        "gck_id": "digitex-futures-exchange"
    },
    {
        "asset": "ALGO",
        "gck_id": "algorand"
    },
    {
        "asset": "ALPHA",
        "gck_id": "alpha-venture-dao"
    },
    {
        "asset": "AAVE",
        "gck_id": "aave"
    },
    {
        "asset": "ALPACA",
        "gck_id": "alpaca-finance"
    },
    {
        "asset": "ALBT",
        "gck_id": "allianceblock"
    },
    {
        "asset": "AKT",
        "gck_id": "akash-network"
    },
    {
        "asset": "AKRO",
        "gck_id": "akropolis"
    },
    {
        "asset": "AIPAD",
        "gck_id": "aipad"
    },
    {
        "asset": "AION",
        "gck_id": "aion"
    },
    {
        "asset": "AI",
        "gck_id": "chat-ai"
    },
    {
        "asset": "AGIX",
        "gck_id": "singularitynet"
    },
    {
        "asset": "AGI",
        "gck_id": "delysium"
    },
    {
        "asset": "AFK",
        "gck_id": "afkdao"
    },
    {
        "asset": "AE",
        "gck_id": "aeternity"
    },
    {
        "asset": "ADX",
        "gck_id": "adex"
    },
    {
        "asset": "ACT",
        "gck_id": "acet"
    },
    {
        "asset": "ACQ",
        "gck_id": "acquire-fi"
    },
    {
        "asset": "ACOIN",
        "gck_id": "acoin"
    },
    {
        "asset": "ACM",
        "gck_id": "ac-milan-fan-token"
    },
    {
        "asset": "ACE",
        "gck_id": "acent"
    },
    {
        "asset": "ACA",
        "gck_id": "acala"
    },
    {
        "asset": "ABBC",
        "gck_id": "abbc"
    },
    {
        "asset": "2CRZ",
        "gck_id": "2crazynft"
    },
    {
        "asset": "1EARTH",
        "gck_id": "earthfund"
    },
    {
        "asset": "$ADS",
        "gck_id": "alkimi"
    },
    {
        "asset": "00",
        "gck_id": "zer0zer0"
    },
    {
        "asset": "1INCH",
        "gck_id": "1inch"
    },
    {
        "asset": "ACH",
        "gck_id": "alchemy-pay"
    },
    {
        "asset": "ACS",
        "gck_id": "access-protocol"
    },
    {
        "asset": "AERGO",
        "gck_id": "aergo"
    },
    {
        "asset": "AGLD",
        "gck_id": "adventure-gold"
    },
    {
        "asset": "ALCX",
        "gck_id": "alchemix"
    },
    {
        "asset": "ALEPH",
        "gck_id": "aleph"
    },
    {
        "asset": "ALICE",
        "gck_id": "my-neighbor-alice"
    },
    {
        "asset": "AMP",
        "gck_id": "amp-token"
    },
    {
        "asset": "ANKR",
        "gck_id": "ankr"
    },
    {
        "asset": "ANT",
        "gck_id": "aragon"
    },
    {
        "asset": "APE",
        "gck_id": "apecoin"
    },
    {
        "asset": "API3",
        "gck_id": "api3"
    },
    {
        "asset": "ARPA",
        "gck_id": "arpa"
    },
    {
        "asset": "ASTR",
        "gck_id": "astrotools"
    },
    {
        "asset": "ATA",
        "gck_id": "automata"
    },
    {
        "asset": "AUCTION",
        "gck_id": "auction"
    },
    {
        "asset": "AURORA",
        "gck_id": "aurora-near"
    },
    {
        "asset": "BADGER",
        "gck_id": "badger-dao"
    },
    {
        "asset": "BAND",
        "gck_id": "band-protocol"
    },
    {
        "asset": "BICO",
        "gck_id": "biconomy"
    },
    {
        "asset": "BLUR",
        "gck_id": "blur"
    },
    {
        "asset": "BLZ",
        "gck_id": "bluzelle"
    },
    {
        "asset": "BNT",
        "gck_id": "bancor"
    },
    {
        "asset": "BOBA",
        "gck_id": "boba-network"
    },
    {
        "asset": "BOND",
        "gck_id": "barnbridge"
    },
    {
        "asset": "C98",
        "gck_id": "coin98"
    },
    {
        "asset": "CBETH",
        "gck_id": "coinbase-wrapped-staked-eth"
    },
    {
        "asset": "CELR",
        "gck_id": "celer-network"
    },
    {
        "asset": "CHZ",
        "gck_id": "chiliz"
    },
    {
        "asset": "CLV",
        "gck_id": "clover-finance"
    },
    {
        "asset": "COMP",
        "gck_id": "compound-governance-token"
    },
    {
        "asset": "COTI",
        "gck_id": "coti"
    },
    {
        "asset": "CTSI",
        "gck_id": "cartesi"
    },
    {
        "asset": "CVC",
        "gck_id": "civic"
    },
    {
        "asset": "DAR",
        "gck_id": "mines-of-dalarnia"
    },
    {
        "asset": "DASH",
        "gck_id": "dash"
    },
    {
        "asset": "DIA",
        "gck_id": "dia-data"
    },
    {
        "asset": "APT",
        "gck_id": "aptos"
    },
    {
        "asset": "ATOM",
        "gck_id": "cosmos"
    },
    {
        "asset": "AUDIO",
        "gck_id": "audius"
    },
    {
        "asset": "AVAX",
        "gck_id": "avalanche-2"
    },
    {
        "asset": "AXS",
        "gck_id": "axie-infinity"
    },
    {
        "asset": "BAL",
        "gck_id": "balancer"
    },
    {
        "asset": "BAT",
        "gck_id": "basic-attention-token"
    },
    {
        "asset": "BCH",
        "gck_id": "bitcoin-cash"
    },
    {
        "asset": "BTC",
        "gck_id": "bitcoin"
    },
    {
        "asset": "CELO",
        "gck_id": "celo"
    },
    {
        "asset": "CRO",
        "gck_id": "crypto-com-chain"
    },
    {
        "asset": "CRV",
        "gck_id": "curve-dao-token"
    },
    {
        "asset": "DAI",
        "gck_id": "dai"
    },
    {
        "asset": "DNT",
        "gck_id": "district0x"
    },
    {
        "asset": "DOCK",
        "gck_id": "dock"
    },
    {
        "asset": "DREP",
        "gck_id": "drep-new"
    },
    {
        "asset": "ELA",
        "gck_id": "elastos"
    },
    {
        "asset": "ENS",
        "gck_id": "ethereum-name-service"
    },
    {
        "asset": "ERN",
        "gck_id": "ethernity-chain"
    },
    {
        "asset": "FARM",
        "gck_id": "harvest-finance"
    },
    {
        "asset": "FET",
        "gck_id": "fetch-ai"
    },
    {
        "asset": "FIDA",
        "gck_id": "bonfida"
    },
    {
        "asset": "FIS",
        "gck_id": "stafi"
    },
    {
        "asset": "DYP",
        "gck_id": "defi-yield-protocol"
    },
    {
        "asset": "FLUX",
        "gck_id": "zelcash"
    },
    {
        "asset": "DOGE",
        "gck_id": "dogecoin"
    },
    {
        "asset": "DOT",
        "gck_id": "polkadot"
    },
    {
        "asset": "EGLD",
        "gck_id": "elrond-erd-2"
    },
    {
        "asset": "ENJ",
        "gck_id": "enjincoin"
    },
    {
        "asset": "EOS",
        "gck_id": "eos"
    },
    {
        "asset": "EUR",
        "gck_id": "tether-eurt"
    },
    {
        "asset": "FIL",
        "gck_id": "filecoin"
    },
    {
        "asset": "FLOW",
        "gck_id": "flow"
    },
    {
        "asset": "FORT",
        "gck_id": "forta"
    },
    {
        "asset": "FORTH",
        "gck_id": "ampleforth-governance-token"
    },
    {
        "asset": "FX",
        "gck_id": "fx-coin"
    },
    {
        "asset": "GAL",
        "gck_id": "project-galaxy"
    },
    {
        "asset": "GALA",
        "gck_id": "gala"
    },
    {
        "asset": "GHST",
        "gck_id": "aavegotchi"
    },
    {
        "asset": "GLM",
        "gck_id": "golem"
    },
    {
        "asset": "GMT",
        "gck_id": "stepn"
    },
    {
        "asset": "GNO",
        "gck_id": "gnosis"
    },
    {
        "asset": "GODS",
        "gck_id": "gods-unchained"
    },
    {
        "asset": "GRT",
        "gck_id": "the-graph"
    },
    {
        "asset": "GTC",
        "gck_id": "gitcoin"
    },
    {
        "asset": "HFT",
        "gck_id": "hashflow"
    },
    {
        "asset": "HIGH",
        "gck_id": "highstreet"
    },
    {
        "asset": "HBAR",
        "gck_id": "hedera-hashgraph"
    },
    {
        "asset": "GBP",
        "gck_id": "poundtoken"
    },
    {
        "asset": "GST",
        "gck_id": "grearn"
    },
    {
        "asset": "ICP",
        "gck_id": "internet-computer"
    },
    {
        "asset": "IDEX",
        "gck_id": "aurora-dao"
    },
    {
        "asset": "ILV",
        "gck_id": "illuvium"
    },
    {
        "asset": "IMX",
        "gck_id": "immutable-x"
    },
    {
        "asset": "INJ",
        "gck_id": "injective-protocol"
    },
    {
        "asset": "JASMY",
        "gck_id": "jasmycoin"
    },
    {
        "asset": "JPY",
        "gck_id": "jpy-coin"
    },
    {
        "asset": "JUP",
        "gck_id": "jupiter"
    },
    {
        "asset": "KRL",
        "gck_id": "kryll"
    },
    {
        "asset": "LIT",
        "gck_id": "litentry"
    },
    {
        "asset": "HKC",
        "gck_id": "helpkidz-coin"
    },
    {
        "asset": "KAVA",
        "gck_id": "kava"
    },
    {
        "asset": "KNC",
        "gck_id": "kyber-network-crystal"
    },
    {
        "asset": "KSM",
        "gck_id": "kusama"
    },
    {
        "asset": "LDO",
        "gck_id": "lido-dao"
    },
    {
        "asset": "LINK",
        "gck_id": "chainlink"
    },
    {
        "asset": "IOTA",
        "gck_id": "iota"
    },
    {
        "asset": "KDA",
        "gck_id": "kadena"
    },
    {
        "asset": "LINA",
        "gck_id": "linear"
    },
    {
        "asset": "LOKA",
        "gck_id": "league-of-kingdoms"
    },
    {
        "asset": "LQTY",
        "gck_id": "liquity"
    },
    {
        "asset": "LRC",
        "gck_id": "loopring"
    },
    {
        "asset": "MAGIC",
        "gck_id": "magic"
    },
    {
        "asset": "MDT",
        "gck_id": "measurable-data-token"
    },
    {
        "asset": "METIS",
        "gck_id": "metis-token"
    },
    {
        "asset": "MINA",
        "gck_id": "mina-protocol"
    },
    {
        "asset": "MIR",
        "gck_id": "mirror-protocol"
    },
    {
        "asset": "MLN",
        "gck_id": "melon"
    },
    {
        "asset": "MTL",
        "gck_id": "metal"
    },
    {
        "asset": "MXC",
        "gck_id": "mxc"
    },
    {
        "asset": "LOOM",
        "gck_id": "loom-network-new"
    },
    {
        "asset": "LPT",
        "gck_id": "livepeer"
    },
    {
        "asset": "LTC",
        "gck_id": "litecoin"
    },
    {
        "asset": "MKR",
        "gck_id": "maker"
    },
    {
        "asset": "NEAR",
        "gck_id": "near"
    },
    {
        "asset": "NEXO",
        "gck_id": "nexo"
    },
    {
        "asset": "NKN",
        "gck_id": "nkn"
    },
    {
        "asset": "NMR",
        "gck_id": "numeraire"
    },
    {
        "asset": "OCEAN",
        "gck_id": "ocean-protocol"
    },
    {
        "asset": "OGN",
        "gck_id": "origin-protocol"
    },
    {
        "asset": "OMG",
        "gck_id": "omisego"
    },
    {
        "asset": "OOKI",
        "gck_id": "ooki"
    },
    {
        "asset": "OP",
        "gck_id": "optimism"
    },
    {
        "asset": "ORN",
        "gck_id": "orion-protocol"
    },
    {
        "asset": "OXT",
        "gck_id": "orchid-protocol"
    },
    {
        "asset": "PERP",
        "gck_id": "perpetual-protocol"
    },
    {
        "asset": "PLU",
        "gck_id": "pluton"
    },
    {
        "asset": "POLS",
        "gck_id": "polkastarter"
    },
    {
        "asset": "LUNA",
        "gck_id": "terra-luna-2"
    },
    {
        "asset": "NEO",
        "gck_id": "neo"
    },
    {
        "asset": "NULS",
        "gck_id": "nuls"
    },
    {
        "asset": "NYC",
        "gck_id": "newyorkcoin"
    },
    {
        "asset": "ONE",
        "gck_id": "harmony"
    },
    {
        "asset": "POND",
        "gck_id": "marlin"
    },
    {
        "asset": "POWR",
        "gck_id": "power-ledger"
    },
    {
        "asset": "PRQ",
        "gck_id": "parsiq"
    },
    {
        "asset": "PUNDIX",
        "gck_id": "pundi-x-2"
    },
    {
        "asset": "PYR",
        "gck_id": "vulcan-forged"
    },
    {
        "asset": "QI",
        "gck_id": "benqi"
    },
    {
        "asset": "QNT",
        "gck_id": "quant-network"
    },
    {
        "asset": "QSP",
        "gck_id": "quantstamp"
    },
    {
        "asset": "QUICK",
        "gck_id": "quick"
    },
    {
        "asset": "RAD",
        "gck_id": "radicle"
    },
    {
        "asset": "RARE",
        "gck_id": "superrare"
    },
    {
        "asset": "REP",
        "gck_id": "augur"
    },
    {
        "asset": "REQ",
        "gck_id": "request-network"
    },
    {
        "asset": "RLC",
        "gck_id": "iexec-rlc"
    },
    {
        "asset": "RNDR",
        "gck_id": "render-token"
    },
    {
        "asset": "ROSE",
        "gck_id": "oasis-network"
    },
    {
        "asset": "RPL",
        "gck_id": "rocket-pool"
    },
    {
        "asset": "QTUM",
        "gck_id": "qtum"
    },
    {
        "asset": "POLY",
        "gck_id": "polymath"
    },
    {
        "asset": "REN",
        "gck_id": "republic-protocol"
    },
    {
        "asset": "RLY",
        "gck_id": "rally-2"
    },
    {
        "asset": "SAND",
        "gck_id": "the-sandbox"
    },
    {
        "asset": "SHIB",
        "gck_id": "shiba-inu"
    },
    {
        "asset": "RAY",
        "gck_id": "raydium"
    },
    {
        "asset": "RFOX",
        "gck_id": "redfox-labs-2"
    },
    {
        "asset": "RUNE",
        "gck_id": "thorchain-erc20"
    },
    {
        "asset": "SKL",
        "gck_id": "skale"
    },
    {
        "asset": "SNT",
        "gck_id": "status"
    },
    {
        "asset": "SPELL",
        "gck_id": "spell-token"
    },
    {
        "asset": "STORJ",
        "gck_id": "storj"
    },
    {
        "asset": "STX",
        "gck_id": "blockstack"
    },
    {
        "asset": "SUKU",
        "gck_id": "suku"
    },
    {
        "asset": "SUSHI",
        "gck_id": "sushi"
    },
    {
        "asset": "SWFTC",
        "gck_id": "swftcoin"
    },
    {
        "asset": "SYLO",
        "gck_id": "sylo"
    },
    {
        "asset": "TONE",
        "gck_id": "te-food"
    },
    {
        "asset": "SNX",
        "gck_id": "havven"
    },
    {
        "asset": "SOL",
        "gck_id": "solana"
    },
    {
        "asset": "STORM",
        "gck_id": "storm-token"
    },
    {
        "asset": "SUPER",
        "gck_id": "superfarm"
    },
    {
        "asset": "SXP",
        "gck_id": "swipe"
    },
    {
        "asset": "TRAC",
        "gck_id": "origintrail"
    },
    {
        "asset": "TRB",
        "gck_id": "tellor"
    },
    {
        "asset": "TRU",
        "gck_id": "truefi"
    },
    {
        "asset": "UMA",
        "gck_id": "uma"
    },
    {
        "asset": "UNFI",
        "gck_id": "unifi-protocol-dao"
    },
    {
        "asset": "USDD",
        "gck_id": "usdd"
    },
    {
        "asset": "VGX",
        "gck_id": "ethos"
    },
    {
        "asset": "VOXEL",
        "gck_id": "voxies"
    },
    {
        "asset": "UNI",
        "gck_id": "uniswap"
    },
    {
        "asset": "USDP",
        "gck_id": "paxos-standard"
    },
    {
        "asset": "WBTC",
        "gck_id": "wrapped-bitcoin"
    },
    {
        "asset": "TROY",
        "gck_id": "troy"
    },
    {
        "asset": "TVK",
        "gck_id": "the-virtua-kolect"
    },
    {
        "asset": "UST",
        "gck_id": "terrausd-wormhole"
    },
    {
        "asset": "USTC",
        "gck_id": "terrausd"
    },
    {
        "asset": "WABI",
        "gck_id": "wabi"
    },
    {
        "asset": "XCN",
        "gck_id": "chain-2"
    },
    {
        "asset": "XLM",
        "gck_id": "stellar"
    },
    {
        "asset": "XTZ",
        "gck_id": "tezos"
    },
    {
        "asset": "XYO",
        "gck_id": "xyo-network"
    },
    {
        "asset": "YFII",
        "gck_id": "yfii-finance"
    },
    {
        "asset": "ZEC",
        "gck_id": "zcash"
    },
    {
        "asset": "ZEN",
        "gck_id": "zencash"
    },
    {
        "asset": "WAXP",
        "gck_id": "wax"
    },
    {
        "asset": "XRP",
        "gck_id": "ripple"
    },
    {
        "asset": "YFI",
        "gck_id": "yearn-finance"
    },
    {
        "asset": "ZRX",
        "gck_id": "0x"
    },
    {
        "asset": "ZIL",
        "gck_id": "zilliqa"
    },
    {
        "asset": "AMPL",
        "gck_id": "ampleforth"
    },
    {
        "asset": "COV",
        "gck_id": "covesting"
    },
    {
        "asset": "ADA",
        "gck_id": "cardano"
    },
    {
        "asset": "ATLAS",
        "gck_id": "star-atlas"
    },
    {
        "asset": "DAO",
        "gck_id": "dao-maker"
    },
    {
        "asset": "BIFI",
        "gck_id": "beefy-finance"
    },
    {
        "asset": "CTK",
        "gck_id": "certik"
    },
    {
        "asset": "BTG",
        "gck_id": "bitcoin-gold"
    },
    {
        "asset": "WMT",
        "gck_id": "world-mobile-token"
    },
    {
        "asset": "HIMEEBITS",
        "gck_id": "himeebits"
    },
    {
        "asset": "CHF",
        "gck_id": "cryptofranc"
    },
    {
        "asset": "DGB",
        "gck_id": "digibyte"
    },
    {
        "asset": "BRL",
        "gck_id": "borealis"
    },
    {
        "asset": "AUD",
        "gck_id": "auditchain"
    },
    {
        "asset": "CHESS",
        "gck_id": "tranchess"
    },
    {
        "asset": "BURGER",
        "gck_id": "burger-swap"
    },
    {
        "asset": "CQT",
        "gck_id": "covalent"
    },
    {
        "asset": "BNS",
        "gck_id": "bns-token-old"
    },
    {
        "asset": "CITY",
        "gck_id": "manchester-city-fan-token"
    },
    {
        "asset": "CND",
        "gck_id": "cindicator"
    },
    {
        "asset": "WING",
        "gck_id": "wing-finance"
    },
    {
        "asset": "CAD",
        "gck_id": "cad-coin"
    },
    {
        "asset": "BAKE",
        "gck_id": "bakerytoken"
    },
    {
        "asset": "BETA",
        "gck_id": "beta-finance"
    },
    {
        "asset": "ASR",
        "gck_id": "as-roma-fan-token"
    },
    {
        "asset": "CVX",
        "gck_id": "convex-finance"
    },
    {
        "asset": "AURY",
        "gck_id": "aurory"
    },
    {
        "asset": "CUSD",
        "gck_id": "celo-dollar"
    },
    {
        "asset": "IOTX",
        "gck_id": "iotex"
    },
    {
        "asset": "CLH",
        "gck_id": "cleardao"
    },
    {
        "asset": "BNX",
        "gck_id": "binaryx-2"
    },
    {
        "asset": "CEUR",
        "gck_id": "celo-euro"
    },
    {
        "asset": "DATA",
        "gck_id": "streamr"
    },
    {
        "asset": "CS",
        "gck_id": "credits"
    },
    {
        "asset": "SNM",
        "gck_id": "sonm"
    },
    {
        "asset": "ASD",
        "gck_id": "asd"
    },
    {
        "asset": "AR",
        "gck_id": "arweave"
    },
    {
        "asset": "BOSON",
        "gck_id": "boson-protocol"
    },
    {
        "asset": "ARB",
        "gck_id": "arbitrum"
    },
    {
        "asset": "DC",
        "gck_id": "dogechain"
    },
    {
        "asset": "BUSD",
        "gck_id": "binance-usd"
    },
    {
        "asset": "DENT",
        "gck_id": "dent"
    },
    {
        "asset": "CARD",
        "gck_id": "cardstack"
    },
    {
        "asset": "CCD",
        "gck_id": "concordium"
    },
    {
        "asset": "AZERO",
        "gck_id": "aleph-zero"
    },
    {
        "asset": "BNC",
        "gck_id": "bifrost-native-coin"
    },
    {
        "asset": "CFG",
        "gck_id": "centrifuge"
    },
    {
        "asset": "BEAM",
        "gck_id": "beam"
    },
    {
        "asset": "BNB",
        "gck_id": "binancecoin"
    }
]
    

def query_asset_id_list():
    response = Assets.select(Assets.id.distinct())
    return [i.id for i in response]


def main(gck_talos_map_list):
    """
    获取gck数据，是看否重复;
    获取asset list;
    获取爬取的gck list;
    对比两者的差集，并记录下来;
    更新gck_id到assets中
    """
    with db.atomic():
        asset_list = query_asset_id_list()
        gck_id_list = [i['gck_id'] for i in gck_talos_map_list]
        gck_id_list.sort()
        gck_id_set = set(gck_id_list)
        repeat_list = []

        for index, i in enumerate(gck_id_list):
            if index > 0:
                if gck_id_list[index - 1] == i:
                    repeat_list.append(i)

        if len(gck_id_set) < len(gck_id_list):
            logger.info(f"存在重复数据，请检查数据！ repeat_list: {repeat_list}")
            return

        asset_id_set = set(asset_list)
        # assets表 比 gck多的数据
        gck_asset_id_set = {i['asset'] for i in gck_talos_map_list}
        asset_diff = asset_id_set - gck_asset_id_set
        gck_asset_diff = gck_asset_id_set - asset_id_set


        for each_gck_talos_map in gck_talos_map_list:
            asset = each_gck_talos_map['asset']
            gck_id = each_gck_talos_map['gck_id']
            Assets.update({"coingecko_id": gck_id}).where(Assets.id==asset).execute()

        # logger.info(f"assets表数据: {asset_id_set}")
        # logger.info(f"gck数据: {gck_asset_id_set}")
        logger.info(f"assets表数据比gck_id多了: {asset_diff}")
        logger.info(f"gck_id表数据比assets多了: {gck_asset_diff}")


if __name__ == "__main__":
    # gck_talos_map_list = [{"asset": "SOS", "gck_id": "opendao"}, {"asset": "WASSD", "gck_id": "sdadads"}]
    main(gck_talos_map_list)
