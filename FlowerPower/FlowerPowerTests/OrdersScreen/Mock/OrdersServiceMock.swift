//
//  File.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import Foundation
@testable import FlowerPower

extension Order {
    static func mock() -> Order {
        Order(id: "unique_id", description: "description", price: 20, customerId: "customer_id", imageUrl: "url_string", status: .new)
    }
}

final class OrdersServiceMock: OrdersServiceType {
    var isSuccessful: Bool = true
    
    func fetchOrders(completion: @escaping ((Result<[Order], Error>) -> Void)) {
        guard isSuccessful else {
            completion(.failure(APIError.invalidResponse))
            return
        }
        completion(.success([Order.mock()]))
    }
    
    
}
