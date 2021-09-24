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
    @Published var savedCoins: [CoinModel] = []
    @Published var savedCoinEntities: [CoinEntity] = []
    @Published var portfolios: [PortfolioEntity] = []
    
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
            .combineLatest(accountDataService.$currentCoins)
            .map(mapDataToCoins)
            .sink { [weak self] returned in
                guard let self = self else { return }
                self.allCoins = returned.allCoins
                self.savedCoins = returned.savedCoins
                
                self.coinsMarketChartService.update(coins: returned.savedCoins)
                self.coinsMarketChartService.getMarketChart()
                
                self.savedCoinEntities = returned.savedEntities
                self.isLoading = self.savedCoinEntities.count > self.savedCoins.count
            }
            .store(in: &cancellables)
        
        accountDataService.$currentPortfolios
            .sink { [weak self] returnedPortfolios in
                self?.portfolios = returnedPortfolios
            }
            .store(in: &cancellables)
        
        coinsMarketChartService.$marketChartDictionary
            .sink { [weak self] returnedDictionary in
                for (coinID, coinMarketChart) in returnedDictionary {
                    if let index = self?.savedCoins.firstIndex(where: {$0.id == coinID}) {
                        self?.savedCoins[index].updateTodayPrices(with: self?.getTodayPrices(from: coinMarketChart))
                    }
                }
            }
            .store(in: &cancellables)
        
        
        // Fetch market chart data every 60 s
//        Timer.publish(every: 60, tolerance: 10, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self]_ in
//                self?.coinMarketChartService.getCoinMarketChart()
//            }
//            .store(in: &cancellables)
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
    
    private func mapDataToCoins(allCoins: [CoinModel], coinEntities: [CoinEntity]) -> (savedCoins: [CoinModel], savedEntities: [CoinEntity], allCoins: [CoinModel]) {
        (coinEntities.compactMap { coinEntity in allCoins.first(where: { $0.id == coinEntity.coinID }) }, coinEntities, allCoins)
    }
    
    func getCoinEntity(of coin: CoinModel) -> CoinEntity? {
        guard let coinEntity = savedCoinEntities.first(where: {$0.coinID == coin.id}) else { return nil}
        return coinEntity
    }
    
    func add(coin: CoinModel) { accountDataService.add(coin: coin) }
    
    func addOrder(coin coinID: String, amount: Double, price: Double) {
        accountDataService.addCoinOrder(coinID: coinID, amount: amount, price: price)
    }
    
    func delete(coin: CoinModel) { accountDataService.delete(coin: coin) }
    
    func delete(at offset: IndexSet) { offset.map({ savedCoins[$0] }).forEach { coin in accountDataService.delete(coin: coin) } }
    
    func move(from source: IndexSet, to destination: Int) {
//        source.map({ savedCoins[$0] }).forEach { coin in accountDataService.move(coin: coin, to: destination)}
        accountDataService.moveCoin(from: source, to: destination)
    }
    
    func refreshAllCoins() {
        self.isLoading = true
        coinDataService.getCoins()
    }
}
