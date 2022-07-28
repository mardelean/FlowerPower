//
//  OrdersListViewController.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import UIKit

class OrdersListViewController: UIViewController {

    // UI Components
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let viewModel = OrdersListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
        registerCells()
        
        viewModel.startFetchingOrders()
    }

    // MARK: Private methods
    private func setupViewModel() {
        viewModel.onStartLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.startLoading()
            }
        }
        
        viewModel.onFinishLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.stopLoading()
            }
        }
        
        viewModel.onShowError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
        
        viewModel.onOrdersReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.onShowOrderDetails = { [weak self] order in
            DispatchQueue.main.async {
                self?.pushToOrderDetails(order: order)
            }
        }
    }
    
    private func setupUI() {
        title = viewModel.screenTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func registerCells() {
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.cellIdentifier)
    }
    
    private func startLoading() {
        let barButton = UIBarButtonItem(customView: activityIndicator)
        navigationItem.rightBarButtonItem = barButton
        activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        activityIndicator.stopAnimating()
        navigationItem.rightBarButtonItem = nil
    }
    
    private func showError(message: String) {
        let alertController = UIAlertController(title: "Uh oh", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    private func pushToOrderDetails(order: Order) {
        let orderDetailsViewModel = OrderDetailsViewModel(order: order, delegate: self)
        let orderDetailsViewController = OrderDetailsViewController(viewModel: orderDetailsViewModel)
        navigationController?.pushViewController(orderDetailsViewController, animated: true)
    }
}

// MARK: UITableViewDataSource
extension OrdersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.cellIdentifier) as? OrderTableViewCell {
            if let order = viewModel.order(at: indexPath.row) {
                let cellViewModel = OrderTableViewCellViewModel(order: order)
                cell.setup(cellViewModel)
                viewModel.startFetchingImage(for: order) { image in
                    DispatchQueue.main.async {
                        cell.updateImage(image, for: order.id)
                    }
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: UITableViewDelegate
extension OrdersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectOrder(at: indexPath.row)
    }
}

extension OrdersListViewController: OrderDetailsViewModelDelegate {
    func didUpdateOrder(order: Order) {
        viewModel.didUpdateOrder(order: order)
        tableView.reloadData()
    }
}
