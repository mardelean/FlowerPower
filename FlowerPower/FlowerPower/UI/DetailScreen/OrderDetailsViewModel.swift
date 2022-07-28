//
//  OrderDetailsViewModel.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import Foundation
import UIKit
import CoreLocation

protocol OrderDetailsViewModelDelegate: AnyObject {
    func didUpdateOrder(order: Order)
}

final class OrderDetailsViewModel {
    
    enum OrderDetailsError: Error {
        case noCustomerFound
        case failedToFetchCustomers
    }
    
    var onStatusUpdated: (() -> Void)?
    var onImageFetched: ((_ image: UIImage) -> Void)?
    var onStartLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    var onDistanceUpdated: (() -> Void)?
    
    var screenTitle: String { order.description }
    var defaultImage: UIImage { RandomImageProvider.makeImage() }
    var priceString: String { String(format: "Total price: %.f $", order.price) }
    var distanceText: String { "Distance to destination:" }
    var updateButtonText: String { "Update Order" }
    var statusText: String { "Order status:" }
    var statusValue: String { order.status.fullStringValue() }
    var statusColor: UIColor { order.status.color() }
    var distanceToDestination: String = "Loading..."
    private(set) var selectedStatusIndex: Int = 0
    
    private var order: Order
    private let imageDownloader: ImageDownloaderType
    private let delegate: OrderDetailsViewModelDelegate?
    private let customersService: CustomersServiceType
    private let locationManager: LocationService
    private var currentLocation: CLLocation?
    private var customer: Customer?
    
    init(order: Order,
         delegate: OrderDetailsViewModelDelegate? = nil,
         imageDownloader: ImageDownloaderType = ImageDownloader(),
         customersService: CustomersServiceType = CustomersService(),
         locationManager: LocationService = LocationService()) {
        self.order = order
        self.imageDownloader = imageDownloader
        self.delegate = delegate
        self.customersService = customersService
        self.locationManager = locationManager
    }
    
    func numberOfStatusOptions() -> Int {
        OrderStatus.allCases.count
    }
    
    func statusOption(for index: Int) -> String? {
        guard index < OrderStatus.allCases.count else {
            return nil
        }
        return OrderStatus.allCases[index].fullStringValue()
    }
    
    func updateOrderStatus(to statusIndex: Int) {
        guard statusIndex < OrderStatus.allCases.count else {
            return
        }
        let newStatus = OrderStatus.allCases[statusIndex]
        order = Order(id: order.id,
                      description: order.description,
                      price: order.price,
                      customerId: order.customerId,
                      imageUrl: order.imageUrl,
                      status: newStatus)
        refreshSelectedStatus()
    }
    
    func updateOrder() {
        onStartLoading?()
        // Ideally a request to update the order on the backend side would go here
        delegate?.didUpdateOrder(order: order)
        onFinishLoading?()
    }
    
    func viewDidLoad() {
        refreshSelectedStatus()
        startDownloadingImage()
        setupLocationManager()
    }
    
    func viewWillDisappear() {
        locationManager.stopLocationTracking()
    }
    
    // MARK: Private methods
    
    private func setupLocationManager() {
        locationManager.didUpdateCurrentLocation = { [weak self] location in
            if let currentLocation = self?.currentLocation, currentLocation.distance(from: location) < 50 {
                return
            }
            self?.currentLocation = location
            self?.startFetchingCustomerCoordinates()
        }
        locationManager.startLocationTracking()
    }
    
    private func startDownloadingImage() {
        guard let imageURL = URL(string: order.imageUrl) else { return }
        onStartLoading?()
        imageDownloader.downloadImage(from: imageURL) { [weak self] result in
            self?.onFinishLoading?()
            switch result {
            case .success(let image):
                self?.onImageFetched?(image)
            case .failure:
                break
            }
        }
    }
    
    private func startFetchingCustomerCoordinates() {
        if let customer = customer,
           customer.id == order.customerId {
            calculateDistance()
            return
        }
        fetchCustomer { [weak self] result in
            switch result {
            case .success(let customer):
                self?.customer = customer
                self?.calculateDistance()
            case .failure:
                break
            }
        }
    }
    
    private func calculateDistance() {
        guard let customer = customer,
              let currentLocation = currentLocation else {
            return
        }
        let customerLocation = CLLocation(latitude: customer.latitude, longitude: customer.longitude)
        let distance = currentLocation.distance(from: customerLocation) / 1000
        self.distanceToDestination = String(format: "%.2f km", distance)
        self.onDistanceUpdated?()
    }
    
    private func fetchCustomer(completion: @escaping ((Result<Customer, Error>) -> Void)) {
        // Ideally I would expect here a request to fetch only one user based on his id, but I didn't know how to mock that in mockable.io
        customersService.fetchCustomers { [weak self] result in
            switch result {
            case .success(let customers):
                if let customer = customers.first(where: { $0.id == self?.order.customerId }) {
                    completion(.success(customer))
                    return
                }
                completion(.failure(OrderDetailsError.noCustomerFound))
            case .failure:
                completion(.failure(OrderDetailsError.failedToFetchCustomers))
            }
        }
    }
    
    private func refreshSelectedStatus() {
        guard let selectedIndex = OrderStatus.allCases.firstIndex(of: order.status) else { return }
        selectedStatusIndex = selectedIndex
        onStatusUpdated?()
    }
}
