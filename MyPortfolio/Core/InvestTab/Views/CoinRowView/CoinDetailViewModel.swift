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
    
    var coin: CoinModel
    
    private let searchKeywords: String
    
    private let newsDataService: NewsDataService

    private var cancellables = Set<AnyCancellable>()
    
    private let accountDataService = AccountDataService.instance
    
    init(coin: CoinModel) {
        self.coin = coin
        self.searchKeywords = coin.name
        self.newsDataService = NewsDataService(endPoints: .everything, pageSize: 10, keywords: self.searchKeywords)
        addSubscribers()
//        print("\t\tinit \(coin.name) CoinDetailViewModel")
    }
    
    func addSubscribers() {
        newsDataService.$allNews
            .sink { [weak self] returnedNews in
                self?.allNews = returnedNews
            }
            .store(in: &cancellables)
    }
    
    func refreshCoin() {
        newsDataService.getNews()
    }
}
