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
    @Published var savedCoinEntities: [WatchListCoinEntity] = []
    
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
            .combineLatest(accountDataService.$currentWatchListCoins)
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
    
    private func mapDataToCoins(allCoins: [CoinModel], coinEntities: [WatchListCoinEntity]) -> (savedCoins: [CoinModel], savedEntities: [WatchListCoinEntity], allCoins: [CoinModel]) {
        (coinEntities.compactMap { coinEntity in allCoins.first(where: { $0.id == coinEntity.coinID }) }, coinEntities, allCoins)
    }
    
    func add(coin: CoinModel) { accountDataService.add(coin: coin) }
    
    func delete(coin: CoinModel) { accountDataService.delete(coin: coin) }
    
    func delete(at offset: IndexSet) { offset.map({ savedCoins[$0] }).forEach { coin in accountDataService.delete(coin: coin) } }
    
    func move(from source: IndexSet, to destination: Int) {
        source.map({ savedCoins[$0] }).forEach { coin in accountDataService.move(coin: coin, to: destination)}
    }
    
    func refreshAllCoins() {
        self.isLoading = true
        coinDataService.getCoins()
    }
}
