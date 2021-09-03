//
//  BrowseTabViewModel.swift
//  BrowseTabViewModel
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import Foundation
import Combine

class BrowseTabViewModel: ObservableObject {
    @Published var allNews: [NewsModel] = []
    
    private let newsDataService = NewsDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        newsDataService.$allNews
            .sink { [weak self] returnedNews in
                self?.allNews = returnedNews
            }
            .store(in: &cancellables)
    }
    
    func refreshNews() {
        newsDataService.getNews()
    }
}
