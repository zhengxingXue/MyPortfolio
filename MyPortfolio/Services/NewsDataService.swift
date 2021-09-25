//
//  NewsDataService.swift
//  NewsDataService
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation
import Combine

enum NewsEndPoints {
    case everything, headlines
}

class NewsDataService {
    
    @Published var allNews: [NewsModel] = []
    
    var newsSubscription: AnyCancellable?
    
    private let endPoints: NewsEndPoints
    private var searchKeywords: String? = nil
    private var pageSize: Int = 20
    
    init() {
        self.endPoints = .headlines
        getNews()
    }
    
    init(endPoints: NewsEndPoints, pageSize: Int, keywords: String? = nil) {
        self.endPoints = endPoints
        self.pageSize = pageSize
        self.searchKeywords = keywords
        getNews()
    }
    
    func getNews() {
        guard let url = URL(string: urlString) else { return }
        
        newsSubscription = NetworkManager.download(url: url)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] newsResponse in
                guard let self = self else { return }
                self.allNews = newsResponse.articles
                self.newsSubscription?.cancel()
//                print("\(self.allNews.count) news for \(self.searchKeywords ?? "unknown") recieved from NewsAPI")
            })
    }
    
    private var urlString: String {
        switch self.endPoints {
        case .headlines: return "https://newsapi.org/v2/top-headlines?country=us&category=business&pageSize=\(pageSize)&apiKey=\(API.news)"
        case .everything: return "https://newsapi.org/v2/everything?qInTitle=\(searchKeywords ?? "business")&language=en&pageSize=\(pageSize)&sortBy=publishedAt&apiKey=\(API.news)"
        }
    }
}
