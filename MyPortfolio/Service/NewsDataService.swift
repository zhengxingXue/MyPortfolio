//
//  NewsDataService.swift
//  NewsDataService
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation
import Combine

class NewsDataService {
    
    @Published var allNews: [NewsModel] = []
    
    var newsSubscription: AnyCancellable?
    
    init() {
        getNews()
    }
    
    func getNews() {
        
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=\(API.news)") else { return }
        
        newsSubscription = NetworkManager.download(url: url)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] newsResponse in
                guard let self = self else { return }
                self.allNews = newsResponse.articles
                self.newsSubscription?.cancel()
                print("\(self.allNews.count) news recieved from NewsAPI")
            })
    }
}
