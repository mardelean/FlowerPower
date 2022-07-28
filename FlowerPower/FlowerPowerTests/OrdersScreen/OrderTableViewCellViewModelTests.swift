//
//  OrderTableViewCellViewModelTests.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import XCTest
@testable import FlowerPower

class OrderTableViewCellViewModelTests: XCTestCase {

    private let mockedOrder = Order.mock()
    private var viewModel: OrderTableViewCellViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = OrderTableViewCellViewModel(order: mockedOrder)
    }
    
    func testInformationIsCorrect() throws {
        XCTAssertEqual(viewModel?.description, "description")
        XCTAssertEqual(viewModel?.imageIdentifier, mockedOrder.id)
        XCTAssertEqual(viewModel?.status, "New order")
        XCTAssertEqual(viewModel?.price, "20 $")
    }

}
