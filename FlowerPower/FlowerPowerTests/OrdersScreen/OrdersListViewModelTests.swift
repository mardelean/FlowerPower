//
//  OrdersListViewModelTests.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import XCTest
@testable import FlowerPower

class OrdersListViewModelTests: XCTestCase {

    func testUIStringsAreCorrect() {
        let orderServiceMock = OrdersServiceMock()
        let imageDownloader = ImageDownloader(imageRequester: ImageRequesterMock())
        let viewModel = OrdersListViewModel(ordersService: orderServiceMock, imageDownloader: imageDownloader)
        XCTAssertEqual(viewModel.screenTitle, "All Orders")
    }
    
    func testOrdersFetchedSuccessful() {
        let orderServiceMock = OrdersServiceMock()
        let imageDownloader = ImageDownloader(imageRequester: ImageRequesterMock())
        let viewModel = OrdersListViewModel(ordersService: orderServiceMock, imageDownloader: imageDownloader)
        let ordersReceivedExpectation = XCTestExpectation(description: "wait for orders received callback to be called")
        let startLoadingExpectation = XCTestExpectation(description: "wait for start loading to be called")
        let finishLoadingExpectation = XCTestExpectation(description: "wait for finish loading to be called")
        
        viewModel.onStartLoading = {
            startLoadingExpectation.fulfill()
        }
        
        viewModel.onFinishLoading = {
            finishLoadingExpectation.fulfill()
        }
        
        viewModel.onOrdersReceived = { [weak viewModel] in
            let numberOfOrders = viewModel?.numberOfItems() ?? 0
            XCTAssertEqual(numberOfOrders, 1)
            ordersReceivedExpectation.fulfill()
        }
        
        viewModel.startFetchingOrders()
        wait(for: [startLoadingExpectation, finishLoadingExpectation, ordersReceivedExpectation], timeout: 10)
    }

    func testOrdersFetchFailed() {
        let orderServiceMock = OrdersServiceMock()
        orderServiceMock.isSuccessful = false
        let imageDownloader = ImageDownloader(imageRequester: ImageRequesterMock())
        let viewModel = OrdersListViewModel(ordersService: orderServiceMock, imageDownloader: imageDownloader)
        let expectation = XCTestExpectation(description: "wait for callback to be called")
        viewModel.onShowError = { errorMessage in
            XCTAssertNotNil(errorMessage)
            expectation.fulfill()
        }
        viewModel.startFetchingOrders()
        wait(for: [expectation], timeout: 10)
    }

    func testFetchingImage() {
        let imageDownloader = ImageDownloader(imageRequester: ImageRequesterMock())
        let viewModel = OrdersListViewModel(ordersService: OrdersServiceMock(), imageDownloader: imageDownloader)
        viewModel.startFetchingImage(for: Order.mock()) { image in
            XCTAssertNotNil(image)
        }
    }
}
