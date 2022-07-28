//
//  Customer.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation
import CoreLocation

struct Customer: Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
}

