//
//  ImageRequesterMock.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import Foundation
@testable import FlowerPower

final class ImageRequesterMock: ImageRequestServiceType {
    var isSuccessful: Bool = true
    
    func fetchImageData(from url: URL, completion: @escaping ((Result<Data, Error>) -> Void)) {
        if !isSuccessful {
            completion(.failure(APIError.invalidResponse))
            return
        }
        let image = RandomImageProvider.makeImage()
        if let imageData = image.pngData() {
            completion(.success(imageData))
        }
    }
}
