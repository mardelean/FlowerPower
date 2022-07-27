//
//  OrdersService.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import Foundation

protocol OrdersServiceType {
    func fetchOrders(completion: @escaping ((Result<[Order], Error>) -> Void))
}

final class OrdersService: OrdersServiceType {
    
    func fetchOrders(completion: @escaping ((Result<[Order], Error>) -> Void)) {
        APIRequest<[Order]>().request(path: .orders) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
