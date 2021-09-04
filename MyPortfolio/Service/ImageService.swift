//
//  ImageService.swift
//  ImageService
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import Foundation
import SwiftUI
import Combine

class ImageService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    
    private let fileManager = LocalFileManager.instance
    private let folderName: String
    private let imageName: String
    private var imageUrlString: String
    
    init(news: NewsModel) {
        self.folderName = "news_images"
        self.imageName = "\(news.imageUrl.hash)"
        self.imageUrlString = news.imageUrl
        getImage()
    }
    
    init(coin: CoinModel) {
        self.folderName = "coin_images"
        self.imageName = coin.id
        self.imageUrlString = coin.image
        getImage()
    }
    
    private func getImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Retrieved image \(imageName) from File Manager in folder \(folderName)")
        } else {
            downloadImage()
            print("Downloading image \(imageName) now")
        }
    }
    
    private func downloadImage() {
        guard let url = URL(string: self.imageUrlString) else { return }
        
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
