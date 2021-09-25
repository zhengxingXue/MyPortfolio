//
//  CoinsMarketChartService.swift
//  MyPortfolio
//
//  Created by Jim's MacBook Pro on 9/23/21.
//

import Foundation
import Combine

class CoinsMarketChartService {
    
    @Published var marketChartDictionary: [String: CoinMarketChartModel] = [:]
    
    private var coinIDs: Set<String> = []
    
    private var subscriptionDictionary: [String: AnyCancellable] = [:]

    func update(coins: [CoinModel]) {
        coinIDs.removeAll()
        for coin in coins {
            coinIDs.insert(coin.id)
        }
    }
    
    func update(coinIDs: [String]) {
        for oldCoinID in self.coinIDs {
            if !coinIDs.contains(oldCoinID) {
                self.coinIDs.remove(oldCoinID)
                self.marketChartDictionary[oldCoinID] = nil
            }
        }
        for coinID in coinIDs {
            self.coinIDs.insert(coinID)
        }
    }
    
    func getMarketChart() {
        var index = 0
        let coinIDArray = Array(coinIDs)
        // Fetch market chart every 1 seconds for API usage limit
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            if index < coinIDArray.count {
                self?.getMarketChart(for: coinIDArray[index], days: 1, interval: "5minute")
                index += 1
            } else {
                timer.invalidate()
            }
        }
        print("CoinsMarketChartService.getMarketChart")
    }
    
    private func getMarketChart(for coinID: String, days: Double, interval: String) {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coinID)/market_chart?vs_currency=usd&days=\(days)&interval=\(interval)") else { return }
        subscriptionDictionary[coinID] = NetworkManager.download(url: url)
            .decode(type: CoinMarketChartModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedmarketCharts in
                guard let self = self else { return }
                self.marketChartDictionary[coinID] = returnedmarketCharts
                self.subscriptionDictionary[coinID]?.cancel()
                print("\t\(coinID) chart recieved from coingecko, \(days) days, \(interval) interval")
            })
    }
}
