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
    @Published var coin: CoinModel
    
    private let searchKeywords: String
    
    private lazy var newsDataService = NewsDataService(endPoints: .everything, pageSize: 10, keywords: self.searchKeywords)
    private var cancellables = Set<AnyCancellable>()
    
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
    }
}
