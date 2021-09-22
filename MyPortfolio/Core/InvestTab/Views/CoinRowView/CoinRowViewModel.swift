//
//  CoinRowViewModel.swift
//  CoinRowViewModel
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import Foundation
import Combine

class CoinRowViewModel: ObservableObject {
    @Published var allNews: [NewsModel] = []
    @Published var todayPrices: [[Double]] = []
    
    var coin: CoinModel
    var coinEntity: CoinEntity
    
    private let searchKeywords: String
    
    private lazy var newsDataService = NewsDataService(endPoints: .everything, pageSize: 10, keywords: self.searchKeywords)
    private lazy var coinMarketChartService = CoinMarketChartService(coin: coin)
    private var cancellables = Set<AnyCancellable>()
    
    private let accountDataService = AccountDataService.instance
    
    init(coin: CoinModel, coinEntity: CoinEntity) {
        self.coin = coin
        self.coinEntity = coinEntity
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
            .map(mapTodayPrices)
            .sink { [weak self] returnedTodayPrices in
                self?.todayPrices = returnedTodayPrices
            }
            .store(in: &cancellables)
    }
    
    private func mapTodayPrices(charts: CoinMarketChartModel?) -> [[Double]] {
        guard let prices = charts?.prices else { return [] }
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
    
    func refreshCoin() {
        newsDataService.getNews()
        coinMarketChartService.getCoinMarketChart()
    }
}
