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
    var status: String { order.status.fullStringValue() }
    var statusColor: UIColor { order.status.color() }
    var price: String { String(format: "%.f $", order.price) }
    let defaultImage: UIImage = RandomImageProvider.makeImage()
    var imageIdentifier: String { order.id }
    
    private let order: Order
    
    init(order: Order) {
        self.order = order
    }
    
}
