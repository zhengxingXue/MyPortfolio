//
//  CustomImageViewModel.swift
//  CustomImageViewModel
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import Foundation
import SwiftUI
import Combine

class CustomImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    // TODO: comment out results in crash, future fix
    private var news: NewsModel? = nil
    
    private let imageService: ImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(news: NewsModel) {
        self.imageService = ImageService(news: news)
        self.addSuscribers()
        self.isLoading = true
    }
    
    init(coin: CoinModel) {
        self.imageService = ImageService(coin: coin)
        self.addSuscribers()
        self.isLoading = true
    }
    
    private func addSuscribers() {
        imageService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
    
}
