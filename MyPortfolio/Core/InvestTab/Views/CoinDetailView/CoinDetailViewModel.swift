//
//  CoinDetailViewModel.swift
//  CoinDetailViewModel
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import Foundation
import Combine

class CoinDetailViewModel: ObservableObject {
    @Published var allNews: [NewsModel] = []
    @Published var prices: [[Double]] = []
    
    var coin: CoinModel
    
    private let searchKeywords: String
    
    private lazy var newsDataService = NewsDataService(endPoints: .everything, pageSize: 10, keywords: self.searchKeywords)
    private lazy var coinMarketChartService = CoinMarketChartService(coin: coin)
    private var cancellables = Set<AnyCancellable>()
    
    private let accountDataService = AccountDataService.instance
    
    init(coin: CoinModel) {
        self.coin = coin
        self.searchKeywords = coin.name
        addSubscribers()
    }
    
    func addSubscribers() {
        newsDataService.$allNews
            .sink { [weak self] returnedNews in
                self?.allNews = returnedNews
            }
            .store(in: &cancellables)
        
        coinMarketChartService.$marketCharts
            .sink { [weak self] returnedmarketCharts in
                self?.prices = returnedmarketCharts?.prices ?? []
                
                print("\(String(describing: self?.prices.last))")
            }
            .store(in: &cancellables)
    }
    
    func updateCoinEntityPrice() {
        var startOfDay: Int64
        if let last = prices.last {
            startOfDay = Date(milliseconds: Int64(last[0])).startOfDay.millisecondsSince1970
        } else {
            startOfDay = Date().startOfDay.millisecondsSince1970
        }
        // map only today's prices
        let todayPrices : [[Double]] = prices.compactMap({ dataPoint in
            guard dataPoint.count > 1, Int64(dataPoint[0]) > startOfDay else { return nil }
            return dataPoint
        })
        accountDataService.add(prices: todayPrices, to: coin)
    }
    
    func refreshCoin() {
        newsDataService.getNews()
        coinMarketChartService.getCoinMarketChart()
    }
}
