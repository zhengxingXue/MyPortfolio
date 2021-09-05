//
//  CoinMarketChartModel.swift
//  CoinMarketChartModel
//
//  Created by Jim's MacBook Pro on 9/4/21.
//

import Foundation

// CoinGecko API info
/*
 URL: https://api.coingecko.com/api/v3/coins/bitcoin/market_chart?vs_currency=usd&days=1&interval=1minute
 
 JSON response:
 {
   "prices": [
     [
       1630713600000,
       49934.5282762881
     ],
     [
       1630798826000,
       50004.21228592287
     ]
   ],
   "market_caps": [
     [
       1630713600000,
       937295558515.289
     ],
     [
       1630798826000,
       940503158679.4156
     ]
   ],
   "total_volumes": [
     [
       1630713600000,
       42934455726.28852
     ],
     [
       1630798826000,
       36914848622.593414
     ]
   ]
 }
 */

struct CoinMarketChartModel: Codable {
    let prices, marketCaps, totalVolumes: [[Double]]?

    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
}
