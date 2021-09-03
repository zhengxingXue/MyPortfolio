//
//  NewsImageViewModel.swift
//  NewsImageViewModel
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import Foundation
import SwiftUI
import Combine

class NewsImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let news: NewsModel
    private let dataService: NewsImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(news: NewsModel) {
        self.news = news
        self.dataService = NewsImageService(news: news)
        self.addSuscribers()
        self.isLoading = true
    }
    
    private func addSuscribers() {
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
    
}
