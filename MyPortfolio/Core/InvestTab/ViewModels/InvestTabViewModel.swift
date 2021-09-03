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
    
    private let coinDataService = CoinDataService()
    private let coinCoreDataService = CoinCoreDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    convenience init(coins: [CoinModel]) {
        self.init()
        allCoins = coins
    }
    
    private func addSubscribers() {
        coinDataService.$allCoins
            .combineLatest(coinCoreDataService.$savedEntities)
            .map(mapDataToCoins)
            .sink { [weak self] returned in
                guard let self = self else { return }
                self.allCoins = returned.allCoins
                self.savedCoins = returned.savedCoins
                self.savedCoinEntities = returned.savedEntities
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToCoins(allCoins: [CoinModel], coinEntities: [CoinEntity]) -> (savedCoins: [CoinModel], savedEntities: [CoinEntity], allCoins: [CoinModel]) {
        (coinEntities.compactMap { coinEntity in allCoins.first(where: { $0.id == coinEntity.coinID }) }, coinEntities, allCoins)
    }
    
    func add(coin: CoinModel) { coinCoreDataService.add(coin: coin) }
    
    func delete(coin: CoinModel) { coinCoreDataService.delete(coin: coin) }
    
    func delete(at offset: IndexSet) { offset.map({ savedCoins[$0] }).forEach { coin in coinCoreDataService.delete(coin: coin) } }
    
    func move(from source: IndexSet, to destination: Int) {
        source.map({ savedCoins[$0] }).forEach { coin in coinCoreDataService.move(coin: coin, to: destination)}
    }
    
    func refreshAllCoins() {
        coinDataService.getCoins()
    }
}
