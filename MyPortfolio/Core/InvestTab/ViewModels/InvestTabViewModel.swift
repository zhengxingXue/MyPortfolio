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
    
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    
    private let accountDataService = AccountDataService.instance
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.isLoading = true
        addSubscribers()
    }
    
    convenience init(coins: [CoinModel]) {
        self.init()
        allCoins = coins
    }
    
    private func addSubscribers() {
        coinDataService.$allCoins
            .combineLatest(accountDataService.$currentCoins)
            .map(mapDataToCoins)
            .sink { [weak self] returned in
                guard let self = self else { return }
                self.allCoins = returned.allCoins
                self.savedCoins = returned.savedCoins
                self.savedCoinEntities = returned.savedEntities
                self.isLoading = self.savedCoinEntities.count > self.savedCoins.count
            }
            .store(in: &cancellables)
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
