//
//  CustomersService.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation

protocol CustomersServiceType {
    func fetchCustomers(completion: @escaping ((Result<[Customer], Error>) -> Void))
}

final class CustomersService: CustomersServiceType {
    
    func fetchCustomers(completion: @escaping ((Result<[Customer], Error>) -> Void)) {
        APIRequest<[Customer]>().request(path: .customers) { result in
            switch result {
            case .success(let customers):
                completion(.success(customers))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
