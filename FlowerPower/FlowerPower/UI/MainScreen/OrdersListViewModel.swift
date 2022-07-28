//
//  FlowersListViewModel.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import Foundation
import UIKit

final class OrdersListViewModel {
 
    var screenTitle: String { "All Orders" }
    var onStartLoading: (() -> Void)?
    var onFinishLoading: (() -> Void)?
    var onShowError: ((_ errorMessage: String) -> Void)?
    var onOrdersReceived: (() -> Void)?
    
    private let ordersService: OrdersServiceType
    private let imageDownloader: ImageDownloaderType
    private var orders: [Order]?
    
    init(ordersService: OrdersServiceType = OrdersService(),
         imageDownloader: ImageDownloaderType = ImageDownloader()) {
        self.ordersService = ordersService
        self.imageDownloader = imageDownloader
    }
    
    func startFetchingOrders() {
        onStartLoading?()
        ordersService.fetchOrders {[weak self] result in
            switch result {
            case .success(let orders):
                self?.orders = orders
                self?.onFinishLoading?()
                self?.onOrdersReceived?()
            case .failure(let error):
                print("Error received: \(error)")
                self?.onFinishLoading?()
                self?.onShowError?("Something went wrong. Please try again later")
            }
        }
    }
    
    func numberOfItems() -> Int {
        orders?.count ?? 0
    }
    
    func order(at index: Int) -> Order? {
        guard let orders = orders,
                index < orders.count else {
            return nil
        }
        return orders[index]
    }
    
    func startFetchingImage(for order: Order, completion: @escaping ((UIImage) -> Void)) {
        guard let imageURL = URL(string: order.imageUrl) else { return }
        imageDownloader.downloadImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                completion(image)
            default:
                break
            }
        }
    }
}
