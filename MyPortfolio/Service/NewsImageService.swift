//
//  NewsImageService.swift
//  NewsImageService
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import Foundation
import SwiftUI
import Combine

class NewsImageService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private var news: NewsModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(news: NewsModel) {
        self.news = news
        self.imageName = "\(news.imageUrl.hash)"
        getNewsImage()
    }
    
    private func getNewsImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Retrieved image \(imageName) from File Manager")
        } else {
            downloadNewsImage()
            print("Downloading image \(imageName) now")
        }
    }
    
    private func downloadNewsImage() {
        guard let url = URL(string: news.imageUrl) else { return }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in UIImage(data: data)})
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
