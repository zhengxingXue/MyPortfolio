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
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(coinCoreDataService.$savedEntities)
            .map { allCoins, coinEntities -> [CoinModel] in
                allCoins.compactMap { coin -> CoinModel? in
                    guard let _  = coinEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                    return coin
                }
            }
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.savedCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func add(coin: CoinModel) { coinCoreDataService.add(coin: coin) }
    
    func delete(coin: CoinModel) { coinCoreDataService.delete(coin: coin) }
    
    func delete(at offset: IndexSet) { offset.map({ savedCoins[$0] }).forEach { coin in coinCoreDataService.delete(coin: coin) } }
    
    func refreshAllCoins() {
        coinDataService.getCoins()
    }
}
