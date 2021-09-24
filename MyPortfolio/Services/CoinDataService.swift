//
//  CoinDataService.swift
//  CoinDataService
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    private let coinNumber = 250
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=\(coinNumber)&page=1&sparkline=false&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                guard let self = self else { return }
                self.allCoins = returnedCoins
                self.coinSubscription?.cancel()
                print("\(self.coinNumber) requested \(self.allCoins.count) coins recieved from coingecko")
            })
    }
}
