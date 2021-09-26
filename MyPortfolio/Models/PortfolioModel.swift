//
//  PortfolioModel.swift
//  MyPortfolio
//
//  Created by Jim's MacBook Pro on 9/25/21.
//

import Foundation

struct PortfolioModel: Identifiable {
    var id: UUID { return UUID() }
    
    let name: String
    let rank: Int
    var initValue: Double
    var amount: Double
    
    init(portfolioEntity: PortfolioEntity) {
        self.name = portfolioEntity.name!
        self.rank = Int(portfolioEntity.rank)
        self.initValue = portfolioEntity.initValue
        self.amount = portfolioEntity.amount
    }
    
    func getCoinModel(from allCoins: [CoinModel]) -> CoinModel? {
        let index = rank - 1
        if index >= 0 && index < allCoins.count {
            return allCoins[rank - 1]
        } else {
            return nil
        }
    }
    
    func getHoldingValueString(from allCoins: [CoinModel]) -> String {
        guard let coin = self.getCoinModel(from: allCoins) else { return "-"}
        return (coin.currentPrice * self.amount).asCurrencyWith2Decimals()
    }
    
    func getTotalProfitString(from allCoins: [CoinModel]) -> String {
        guard let coin = self.getCoinModel(from: allCoins) else { return "-"}
        return (coin.currentPrice * self.amount - initValue).asCurrencyWith2Decimals()
    }
    
    func isProfitable(from allCoins: [CoinModel]) -> Bool {
        guard let coin = self.getCoinModel(from: allCoins) else { return true }
        return (coin.currentPrice * self.amount - initValue) >= 0
    }
    
}
