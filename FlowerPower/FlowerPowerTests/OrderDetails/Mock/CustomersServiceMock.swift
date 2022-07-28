//
//  CustomersServiceMock.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation
@testable import FlowerPower

extension Customer {
    static func mock() -> Customer {
        Customer(id: "customer_id", name: "Maria", latitude: 46.756641463075624, longitude: 23.59531158403007)
    }
}

final class CustomersServiceMock: CustomersServiceType {
    var isSuccessful: Bool = true
    
    func fetchCustomers(completion: @escaping ((Result<[Customer], Error>) -> Void)) {
        guard isSuccessful else {
            completion(.failure(APIError.invalidResponse))
            return
        }
        completion(.success([Customer.mock()]))
    }
    
    
}

