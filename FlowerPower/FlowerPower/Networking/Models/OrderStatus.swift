//
//  OrderStatus.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import UIKit

enum OrderStatus: String, CaseIterable, Codable {
    case `new`
    case pending
    case delivered
}

extension OrderStatus {
    func fullStringValue() -> String {
        switch self {
        case .new:
            return "New order"
        case .pending:
            return "In progress"
        case .delivered:
            return "Order delivered"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .new:
            return .blue
        case .pending:
            return .orange
        case .delivered:
            return .green
        }
    }
}
