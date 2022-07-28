//
//  OrderTableViewCellViewModel.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import Foundation
import UIKit

final class OrderTableViewCellViewModel {
    
    var description: String { order.description }
    var status: String { createOrderStatus() }
    var statusColor: UIColor { createStatusColor() }
    var price: String { String(format: "%.f $", order.price) }
    let defaultImage: UIImage = RandomImageProvider.makeImage()
    var imageIdentifier: String { order.id }
    
    private let order: Order
    
    init(order: Order) {
        self.order = order
    }
    
    // MARK: Private methods
    private func createOrderStatus() -> String {
        switch order.status {
        case .new:
            return "New"
        case .pending:
            return "In progress"
        case .delivered:
            return "Order delivered"
        }
    }
    
    private func createStatusColor() -> UIColor {
        switch order.status {
        case .new:
            return .blue
        case .pending:
            return .orange
        case .delivered:
            return .green
        }
    }
    
}
