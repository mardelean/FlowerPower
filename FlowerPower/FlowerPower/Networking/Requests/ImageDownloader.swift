//
//  ImageDownloader.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import UIKit

protocol ImageDownloaderType {
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class ImageDownloader: ImageDownloaderType {
    
    private let imageCache = ImageCache()
    private let imageRequester: ImageRequestServiceType
    
    init(imageRequester: ImageRequestServiceType = ImageRequestService()) {
        self.imageRequester = imageRequester
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let fetchedImage = imageCache.getImage(forKey: url.absoluteString) {
            completion(.success(fetchedImage))
            return
        }
        imageRequester.fetchImageData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self?.imageCache.setImage(image, key: url.absoluteString)
                    completion(.success(image))
                } else {
                    completion(.failure(APIError.invalidResponse))
                }
            case .failure:
                completion(.failure(APIError.invalidResponse))
            }
                
        }
    }
}
