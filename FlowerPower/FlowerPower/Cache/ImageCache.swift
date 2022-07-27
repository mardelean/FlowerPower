//
//  ImageCache.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import UIKit

protocol ImageCacheType {
    func setImage(_ image: UIImage?, key: String)
    func getImage(forKey key: String) -> UIImage?
}

final class ImageCache: ImageCacheType {

    private var imagesDictionary = [String: UIImage]()
    private let dispatchQueue = DispatchQueue(label: "default_image_cache")
    func setImage(_ image: UIImage?, key: String) {
        dispatchQueue.async { [weak self] in
            self?.imagesDictionary[key] = image
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        dispatchQueue.sync { [weak self] in
            return self?.imagesDictionary[key]
        }
    }
}

