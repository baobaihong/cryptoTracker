//
//  CoinImageService.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/19.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getLocalCoinImage()
    }
    
    private func getLocalCoinImage() {
        // firstly,  try to get the image from local file
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            self.image = savedImage
            // print("Retrieved image from FileManager!")
        } else {
            // if not saved before, download the image
            downloadCoinsImage()
            // print("Downloading image now")
        }
    }
    
    private func downloadCoinsImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] returnedImage in
                    guard let self = self, let downloadedImage = returnedImage else { return }
                    self.image = returnedImage
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
                })
        
    }
}
