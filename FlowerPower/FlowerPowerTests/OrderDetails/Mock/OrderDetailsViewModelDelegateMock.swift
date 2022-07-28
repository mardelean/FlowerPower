//
//  OrderDetailsViewModelDelegateMock.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import Foundation
@testable import FlowerPower

final class OrderDetailsViewModelDelegateMock: OrderDetailsViewModelDelegate {
    var didCallUpdateOrder = false
    
    func didUpdateOrder(order: Order) {
        didCallUpdateOrder = true
    }
}
