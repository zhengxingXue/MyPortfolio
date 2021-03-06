//
//  InvestTabViewModel.swift
//  InvestTabViewModel
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation
import Combine
import SwiftUI

class InvestTabViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    
    @Published var savedCoinIndices: [Int] = []
    
    @Published var portfolios: [PortfolioModel] = []
    
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let coinsMarketChartService = CoinsMarketChartService()
    
    private let accountDataService = AccountDataService.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.isLoading = true
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        accountDataService.$currentCoins
            .sink { [weak self] returnedCoinEntities in
                guard let self = self else { return }
                // TODO: make sure the rank is correct to index the coin
                self.savedCoinIndices = returnedCoinEntities.map({ Int($0.rank - 1) })
                self.coinsMarketChartService.update(coinIDs: returnedCoinEntities.map({ $0.coinID ?? "" }))
                self.coinsMarketChartService.getMarketChart()
            }
            .store(in: &cancellables)
        
        accountDataService.$currentPortfolios
            .sink { [weak self] returnedPortfolios in
                self?.portfolios = returnedPortfolios.map({PortfolioModel(portfolioEntity: $0)})
            }
            .store(in: &cancellables)
        
        coinsMarketChartService.$marketChartDictionary
            .sink { [weak self] returnedDictionary in
                guard let self = self else { return }
                for (coinID, coinMarketChart) in returnedDictionary {
                    if let index = self.allCoins.firstIndex(where: {$0.id == coinID}) {
                        self.allCoins[index].updateTodayPrices(with: self.getTodayPrices(from: coinMarketChart))
                    }
                }
            }
            .store(in: &cancellables)
        
        // Fetch market chart data every 60 s
        Timer.publish(every: 60, tolerance: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self]_ in
                self?.coinsMarketChartService.getMarketChart()
            }
            .store(in: &cancellables)
    }
    
    private func getTodayPrices(from charts: CoinMarketChartModel) -> [[Double]] {
        guard let prices = charts.prices else { return [] }
        var startOfDay: Int64
        if let last = prices.last {
            startOfDay = Date(milliseconds: Int64(last[0])).startOfDay.millisecondsSince1970
        } else {
            startOfDay = Date().startOfDay.millisecondsSince1970
        }
        // map only today's prices
        return prices.compactMap({ dataPoint in
            guard dataPoint.count > 1, Int64(dataPoint[0]) > startOfDay else { return nil }
            return dataPoint
        })
    }
    
    func getPortfolioValueString() -> String {
        var value: Double = 0
        for portfolio in portfolios {
            guard let holdingValue = portfolio.getHoldingValue(from: allCoins) else { return "-"}
            value += holdingValue
        }
        return value.asCurrencyWith2Decimals()
    }
    
    func getEquityString() -> String {
        var equity: Double = accountDataService.currentAccount.cash
        for portfolio in portfolios {
            guard let holdingValue = portfolio.getHoldingValue(from: allCoins) else { return "-"}
            equity += holdingValue
        }
        return equity.asCurrencyWith2Decimals()
    }
    
    func getBuyingPowerString() -> String {
        accountDataService.currentAccount.cash.asCurrencyWith2Decimals()
    }
    
    func add(coin: CoinModel) { accountDataService.add(coin: coin) }
    
    func addOrder(coin: CoinModel, amount: Double) {
        accountDataService.addOrder(coin: coin, amount: amount)
    }
    
    func delete(coin: CoinModel) { accountDataService.delete(coin: coin) }
    
    func delete(at offset: IndexSet) { offset.map({ allCoins[savedCoinIndices[$0]] }).forEach { coin in accountDataService.delete(coin: coin) } }
    
    func move(from source: IndexSet, to destination: Int) {
        accountDataService.moveCoin(from: source, to: destination)
    }
    
    func refreshAllCoins() {
        self.isLoading = true
        coinDataService.getCoins()
    }
}
