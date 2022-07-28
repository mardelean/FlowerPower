//
//  Flower.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import Foundation

struct Order: Codable {
    let id: String
    let description: String
    let price: Double
    let customerId: String
    let imageUrl: String
    let status: OrderStatus
}
