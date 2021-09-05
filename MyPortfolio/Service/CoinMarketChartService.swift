//
//  CoinMarketChartService.swift
//  CoinMarketChartService
//
//  Created by Jim's MacBook Pro on 9/4/21.
//

import Foundation
import Combine

class CoinMarketChartService {
    
    @Published var marketCharts: CoinMarketChartModel? = nil
    
    var coinSubscription: AnyCancellable?
    
    let coinID: String
    var days: Double = 1
    var interval: String = "5minute"
    
    init(coin: CoinModel) {
        self.coinID = coin.id
        getCoinMarketChart()
    }
    
    func getCoinMarketChart() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinID)/market_chart?vs_currency=usd&days=\(days)&interval=\(interval)") else { return }
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: CoinMarketChartModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedmarketCharts in
                guard let self = self else { return }
                self.marketCharts = returnedmarketCharts
                self.coinSubscription?.cancel()
                print("\(self.coinID) market chart recieved from coingecko, \(self.days) days, \(self.interval) interval")
            })
    }
}
