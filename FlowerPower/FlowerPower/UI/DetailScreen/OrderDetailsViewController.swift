//
//  OrderDetailsViewController.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 27.07.2022.
//

import Foundation
import UIKit

final class OrderDetailsViewController: UIViewController {
    
    enum Constants {
        static let padding: CGFloat = 15
        static let imageHeight: CGFloat = 200
        static let buttonWidth: CGFloat = 150
        static let buttonHeight: CGFloat = 50
    }
    
    // UI components
    private let imageView = UIImageView()
    
    private let priceLabel = UILabel()
    
    private let statusStackView = UIStackView()
    private let statusLabel = UILabel()
    private let statusValueLabel = UILabel()
    private let statusPickerView = UIPickerView()
    
    private let distanceLabel = UILabel()
    private let distanceValueLabel = UILabel()
    private let distanceStackView = UIStackView()
    
    private let updateButton = UIButton()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let viewModel: OrderDetailsViewModel
    init(viewModel: OrderDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModel()
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    // MARK: Private methods
    
    private func setupViewModel() {
        viewModel.onStatusUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshStatusValue()
            }
        }
        
        viewModel.onImageFetched = { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
        
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
        
        viewModel.onDistanceUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.distanceValueLabel.text = self?.viewModel.distanceToDestination
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = viewModel.screenTitle
        
        setupNavigationBar()
        setupImageView()
        setupPriceLabel()
        setupDistance()
        setupStatus()
        setupUpdateButton()
    }
    
    private func setupNavigationBar() {
        edgesForExtendedLayout = []
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupImageView() {
        imageView.image = viewModel.defaultImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.imageHeight).isActive = true
    }
    
    private func setupPriceLabel() {
        priceLabel.text = viewModel.priceString
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
        priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2 * Constants.padding).isActive = true
    }
    
    private func setupStatus() {
        statusStackView.axis = .horizontal
        statusStackView.distribution = .fillProportionally
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusStackView)
        statusStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        statusStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        statusStackView.topAnchor.constraint(equalTo: distanceStackView.bottomAnchor, constant: Constants.padding).isActive = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = viewModel.statusText
        statusStackView.addArrangedSubview(statusLabel)
        
        statusValueLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusValueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        statusValueLabel.translatesAutoresizingMaskIntoConstraints = false
        statusStackView.addArrangedSubview(statusValueLabel)
        refreshStatusValue()
        
        statusPickerView.dataSource = self
        statusPickerView.delegate = self
        statusPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusPickerView)
        statusPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusPickerView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor).isActive = true
    }
    
    private func setupDistance() {
        distanceStackView.axis = .horizontal
        distanceStackView.distribution = .fillProportionally
        distanceStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceStackView)
        distanceStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding).isActive = true
        distanceStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding).isActive = true
        distanceStackView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.padding).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.text = viewModel.distanceText
        distanceStackView.addArrangedSubview(distanceLabel)
        
        distanceValueLabel.setContentHuggingPriority(.required, for: .horizontal)
        distanceValueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        distanceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceValueLabel.text = viewModel.distanceToDestination
        distanceStackView.addArrangedSubview(distanceValueLabel)
    }
    
    func setupUpdateButton() {
        updateButton.backgroundColor = .black
        updateButton.setTitleColor(.white, for: .normal)
        updateButton.setTitle(viewModel.updateButtonText, for: .normal)
        updateButton.addTarget(self, action: #selector(updateOrder), for: .touchUpInside)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(updateButton)
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2 * Constants.padding).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
    }
    
    private func refreshStatusValue() {
        statusValueLabel.text = viewModel.statusValue
        statusValueLabel.textColor = viewModel.statusColor
        statusPickerView.selectRow(viewModel.selectedStatusIndex, inComponent: 0, animated: false)
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
    
    @objc private func updateOrder() {
        viewModel.updateOrder()
    }
}

// MARK: UIPickerViewDataSource
extension OrderDetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfStatusOptions()
    }
}

// MARK: UIPickerViewDelegate
extension OrderDetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.statusOption(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.updateOrderStatus(to: row)
    }
}
