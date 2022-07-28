//
//  APIConfig.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import Foundation

enum APIPath: String {
    case orders
    case customers
}

enum HTTPMethod: String {
    case get = "GET"
}

enum APIError: Error {
    case invalidResponse
    case invalidURL
}

enum MappingOptions {
    case data
    case json
}

final class APIRequest<T: Codable> {
    private let restHost = "http://demo7708924.mockable.io/"
    private let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    
    func request(url: URL, httpMethod: HTTPMethod? = nil, mappingOptions: MappingOptions = .json, completion: @escaping ((Result<T, Error>) -> Void)) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod?.rawValue
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode),
                      let data = data {
                if mappingOptions == .data,
                   let rawData = data as? T {
                    completion(.success(rawData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(APIError.invalidResponse))
            }
        }
        task.resume()
    }
    
    func request(path: APIPath, httpMethod: HTTPMethod = .get, mappingOptions: MappingOptions = .json, completion: @escaping ((Result<T, Error>) -> Void)) {
        guard let baseURL = URL(string: restHost) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        let url: URL = baseURL.appendingPathComponent(path.rawValue)
        request(url: url, httpMethod: httpMethod, completion: completion)
    }
}
