//
//  ImageRequestService.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import UIKit

protocol ImageRequestServiceType {
    func fetchImageData(from url: URL, completion: @escaping ((Result<Data, Error>) -> Void))
}

final class ImageRequestService: ImageRequestServiceType {
    
    func fetchImageData(from url: URL, completion: @escaping ((Result<Data, Error>) -> Void)) {
        APIRequest<Data>().request(url: url, mappingOptions: .data) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
