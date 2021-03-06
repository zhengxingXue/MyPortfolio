//
//  CoinModel.swift
//  CoinModel
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation

// CoinGecko API info
/*
 
 URL:
    https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=false&price_change_percentage=24h
 
 JSON Response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 48288,
     "market_cap": 907653755795,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 1014049629591,
     "total_volume": 37511578162,
     "high_24h": 49799,
     "low_24h": 47683,
     "price_change_24h": -992.466342776643,
     "price_change_percentage_24h": -2.01393,
     "market_cap_change_24h": -16725940848.248169,
     "market_cap_change_percentage_24h": -1.80942,
     "circulating_supply": 18796643,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 64805,
     "ath_change_percentage": -25.48679,
     "ath_date": "2021-04-14T11:54:46.763Z",
     "atl": 67.81,
     "atl_change_percentage": 71111.90048,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2021-08-25T03:02:29.214Z"
     },
     "price_change_percentage_24h_in_currency": -2.0139284142739124
   }
 */

struct CoinModel: Identifiable, Codable, Hashable {
    let id, symbol, name: String
    let image: String
    let price: Double
    let marketCapRank: Int16
    let marketCap, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let priceChangePercentage24HInCurrency: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case price = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case todayPrices = "today_prices"
    }
    
    var todayPrices: [[Double]]?
    
    mutating func updateTodayPrices(with prices: [[Double]]?) {
        // only update if the prices is new
        if todayPrices?.last != prices?.last {
            self.todayPrices = prices
        }
    }
    
    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var stats: [(titleString: String, valueString: String)] {
        [("24h High", high24H?.asCurrency().replacingOccurrences(of: "$", with: "") ?? "-"),
         ("24h Low", low24H?.asCurrency().replacingOccurrences(of: "$", with: "") ?? "-"),
         ("Supply", totalSupply?.formattedWithAbbreviations() ?? "-"),
         ("Volume", totalVolume?.formattedWithAbbreviations() ?? "-"),
         ("Mkt Cap", marketCap?.formattedWithAbbreviations() ?? "-"),
         ("Rank", "\(marketCapRank)"),
        ]
    }
    
    var todayPricesChange: Double {
        (todayPrices?.last?[1] ?? 0) - (todayPrices?.first?[1] ?? 0)
    }
    
    var currentPrice: Double {
        // TODO: Handle the nil case
        todayPrices?.last?[1] ?? -1
    }
    
}
