//
//  MarketDataModel.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/20.
//

import Foundation

// JSON data:
/*
 URL: https://api.coingecko.com/api/v3/global
 
 JSON Response:
 {
   "data": {
     "active_cryptocurrencies": 12806,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 943,
     "total_market_cap": {
       "btc": 39963871.11311975,
       "eth": 704374736.6867065,
       "ltc": 29671787661.83939,
       "bch": 7740641659.671468,
       "bnb": 5868867757.114211,
       "eos": 2626596023214.4307,
       "xrp": 3678705203987.4995,
       "xlm": 17430791809188.172,
       "link": 107817676207.06754,
       "dot": 266917943100.75876,
       "yfi": 270469658.81375444,
       "usd": 2097176368121.1143,
       "aed": 7702823941290.459,
       "ars": 1755894720692458.5,
       "aud": 3191929695573.119,
       "bdt": 230198954827873.78,
       "bhd": 790450939261.2639,
       "bmd": 2097176368121.1143,
       "brl": 10356695776329.297,
       "cad": 2833299953566.2017,
       "chf": 1846760926709.244,
       "clp": 2021069837721998.2,
       "cny": 15082892439527.033,
       "czk": 49268544980995.875,
       "dkk": 14448685334043.537,
       "eur": 1938273314708.5771,
       "gbp": 1659191569520.8584,
       "gel": 5526059729999.15,
       "hkd": 16402691665865.75,
       "huf": 753143992021479,
       "idr": 32820239433421428,
       "ils": 7681170595289.578,
       "inr": 173921036146294.12,
       "jpy": 314546308307875.3,
       "krw": 2795787820687734.5,
       "kwd": 645538149400.4635,
       "lkr": 656293849758241.2,
       "mmk": 4404498396265181,
       "mxn": 35677269233294.78,
       "myr": 10061203626061.064,
       "ngn": 3188759503110602.5,
       "nok": 21934747223101.363,
       "nzd": 3390911886556.819,
       "php": 117343305131127.94,
       "pkr": 586477078446632,
       "pln": 8378878104023.451,
       "rub": 194003364260845.2,
       "sar": 7865176849828.545,
       "sek": 21735140073559.98,
       "sgd": 2817692767034.6455,
       "thb": 75507786546016.72,
       "try": 64810509327504.53,
       "twd": 65944033154473.91,
       "uah": 80708710537784.11,
       "vef": 209990269739.96713,
       "vnd": 51458143840355730,
       "zar": 39734001061908.18,
       "xdr": 1583152148765.526,
       "xag": 90664394734.88321,
       "xau": 1033698231.8468986,
       "bits": 39963871113119.75,
       "sats": 3996387111311975
     },
     "total_volume": {
       "btc": 1732143.8557264318,
       "eth": 30529534.259264044,
       "ltc": 1286056712.1086953,
       "bch": 335500653.88381,
       "bnb": 254372835.82418117,
       "eos": 113843880394.07806,
       "xrp": 159445179824.53198,
       "xlm": 755498356184.5178,
       "link": 4673113994.691667,
       "dot": 11568956215.889076,
       "yfi": 11722897.322648697,
       "usd": 90897379538.9684,
       "aed": 333861530177.65454,
       "ars": 76105296284759.53,
       "aud": 138346993324.2438,
       "bdt": 9977454488107.543,
       "bhd": 34260313116.791595,
       "bmd": 90897379538.9684,
       "brl": 448887619115.24097,
       "cad": 122802996038.80305,
       "chf": 80043687037.73831,
       "clp": 87598713635499.2,
       "cny": 653733953644.2598,
       "czk": 2135433958033.0837,
       "dkk": 626245677097.8809,
       "eur": 84010085091.30075,
       "gbp": 71913916309.15247,
       "gel": 239514595085.18234,
       "hkd": 710937674330.4825,
       "huf": 32643327633718.88,
       "idr": 1422519252881089.8,
       "ils": 332923014733.9133,
       "inr": 7538215036517.784,
       "jpy": 13633300281014.385,
       "krw": 121177117247013.56,
       "kwd": 27979395088.02844,
       "lkr": 28445576660780.11,
       "mmk": 190903048732510.2,
       "mxn": 1546350765585.9062,
       "myr": 436080178338.2017,
       "ngn": 138209588482258.53,
       "nok": 950712145023.767,
       "nzd": 146971427592.2807,
       "php": 5085980895549.139,
       "pkr": 25419526178539.402,
       "pln": 363163573035.35443,
       "rub": 8408638253373.822,
       "sar": 340898350814.6633,
       "sek": 942060623336.6282,
       "sgd": 122126537740.27411,
       "thb": 3272714701610.7905,
       "try": 2809065348058.42,
       "twd": 2858195381699.2285,
       "uah": 3498137021459.1445,
       "vef": 9101554613.236904,
       "vnd": 2230337181997808.2,
       "zar": 1722180656823.7375,
       "xdr": 68618159121.82868,
       "xag": 3929643698.145845,
       "xau": 44803318.37475759,
       "bits": 1732143855726.432,
       "sats": 173214385572643.2
     },
     "market_cap_percentage": {
       "btc": 49.12663095235615,
       "eth": 17.059214770961272,
       "usdt": 4.629915190118404,
       "bnb": 2.619404238447654,
       "sol": 2.3049086664483225,
       "xrp": 1.4812534086830444,
       "steth": 1.3868750214953223,
       "usdc": 1.3230821554333283,
       "ada": 1.0592722377709627,
       "avax": 0.6891598155913525
     },
     "market_cap_change_percentage_24h_usd": 1.0100958232065775,
     "updated_at": 1708438380
   }
 }
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + "\(item.value.formattedWithAbbreviations())"
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + "\(item.value.formattedWithAbbreviations())"
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }
}
