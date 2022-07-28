//
//  OrderDetailsViewModelTests.swift
//  FlowerPowerTests
//
//  Created by Madalina Ardelean on 28.07.2022.
//

import XCTest
@testable import FlowerPower

class OrderDetailsViewModelTests: XCTestCase {
    
    private let order = Order.mock()
    private var viewModel: OrderDetailsViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = OrderDetailsViewModel(order: order,
                                          delegate: OrderDetailsViewModelDelegateMock(),
                                          imageDownloader: ImageDownloader(imageRequester: ImageRequesterMock()),
                                          customersService: CustomersServiceMock(),
                                          locationManager: LocationService(locationManager: MockLocationManager()))
    }
    
    func testViewModelInformation() {
        XCTAssertEqual(viewModel?.screenTitle, order.description)
        XCTAssertEqual(viewModel?.priceString, "Total price: 20 $")
        XCTAssertEqual(viewModel?.distanceText, "Distance to destination:")
        XCTAssertEqual(viewModel?.updateButtonText, "Update Order")
        XCTAssertEqual(viewModel?.statusText, "Order status:")
        XCTAssertEqual(viewModel?.statusValue, "New order")
        
        XCTAssertEqual(viewModel?.numberOfStatusOptions(), 3)
        XCTAssertEqual(viewModel?.statusOption(for: 2), "Order delivered")
    }
    
    func testStatusRefreshed() {
        viewModel?.viewDidLoad()
        XCTAssertEqual(viewModel?.selectedStatusIndex, 0)
    }
    
    func testViewModelUpdateStatus() {
        XCTAssertEqual(viewModel?.statusValue, "New order")
        viewModel?.updateOrderStatus(to: 1)
        XCTAssertEqual(viewModel?.statusValue, "In progress")
    }
    
    func testViewModelUpdateStatusToInvalid() {
        XCTAssertEqual(viewModel?.statusValue, "New order")
        viewModel?.updateOrderStatus(to: 3)
        XCTAssertEqual(viewModel?.statusValue, "New order")
    }
    
    func testUpdateOrder() {
        let delegate = OrderDetailsViewModelDelegateMock()
        viewModel = OrderDetailsViewModel(order: order,
                                          delegate: delegate,
                                          imageDownloader: ImageDownloader(imageRequester: ImageRequesterMock()),
                                          customersService: CustomersServiceMock(),
                                          locationManager: LocationService(locationManager: MockLocationManager()))
        let startLoadingExpectation = XCTestExpectation(description: "waiting to start loading")
        viewModel?.onStartLoading = {
            startLoadingExpectation.fulfill()
        }
        let finishLoadingExpectation = XCTestExpectation(description: "waiting to finish loading")
        viewModel?.onFinishLoading = {
            finishLoadingExpectation.fulfill()
        }
        
        viewModel?.updateOrder()
        XCTAssertTrue(delegate.didCallUpdateOrder)
        wait(for: [startLoadingExpectation, finishLoadingExpectation], timeout: 10)
    }
    
    func testFetchingImage() {
        let expectation = XCTestExpectation(description: "waiting for image to be downloaded")
        viewModel?.onImageFetched = { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        viewModel?.viewDidLoad()
        wait(for: [expectation], timeout: 10)
    }
    
    func testCalculatedDistance() {
        XCTAssertEqual(viewModel?.distanceToDestination, "Loading...")
        let expectation = XCTestExpectation(description: "waiting for distance to be calculated")
        viewModel?.onDistanceUpdated = { [weak self] in
            XCTAssertEqual(self?.viewModel?.distanceToDestination, "0.91 km")
            expectation.fulfill()
        }
        viewModel?.viewDidLoad()
        wait(for: [expectation], timeout: 10)
    }
    
    func testDistanceLocationOff() {
        let locationManagerMock = MockLocationManager()
        locationManagerMock.enableLocation = false
        viewModel = OrderDetailsViewModel(order: order,
                                          delegate: OrderDetailsViewModelDelegateMock(),
                                          imageDownloader: ImageDownloader(imageRequester: ImageRequesterMock()),
                                          customersService: CustomersServiceMock(),
                                          locationManager: LocationService(locationManager: locationManagerMock))
        XCTAssertEqual(viewModel?.distanceToDestination, "Loading...")
        let expectation = XCTestExpectation(description: "expect distance not to be calculated")
        expectation.isInverted = true
        viewModel?.onDistanceUpdated = {
            expectation.fulfill()
        }
        viewModel?.viewDidLoad()
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(viewModel?.distanceToDestination, "Loading...")
    }
    
    func testLocationUpdatesStarted() {
        let locationManager = MockLocationManager()
        viewModel = OrderDetailsViewModel(order: order,
                                          delegate: OrderDetailsViewModelDelegateMock(),
                                          imageDownloader: ImageDownloader(imageRequester: ImageRequesterMock()),
                                          customersService: CustomersServiceMock(),
                                          locationManager: LocationService(locationManager: locationManager))
        viewModel?.viewDidLoad()
        XCTAssertEqual(locationManager.isUpdatingLocation, true)
    }
    
    func testLocationUpdatesStopped() {
        let locationManager = MockLocationManager()
        viewModel = OrderDetailsViewModel(order: order,
                                          delegate: OrderDetailsViewModelDelegateMock(),
                                          imageDownloader: ImageDownloader(imageRequester: ImageRequesterMock()),
                                          customersService: CustomersServiceMock(),
                                          locationManager: LocationService(locationManager: locationManager))
        viewModel?.viewDidLoad()
        XCTAssertTrue(locationManager.isUpdatingLocation)
        viewModel?.viewWillDisappear()
        XCTAssertFalse(locationManager.isUpdatingLocation)
    }
}
