//
//  OrderTableViewCell.swift
//  FlowerPower
//
//  Created by Madalina Ardelean on 26.07.2022.
//

import UIKit

final class OrderTableViewCell: UITableViewCell {
    enum Constants {
        static let padding: CGFloat = 15
        static let imageSize: CGFloat = 50
    }
    
    var imageIdentifier: String?
    static let cellIdentifier = "OrderTableViewCell"
    
    private let orderImageView = UIImageView()
    private let descriptionStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let statusLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(_ viewModel: OrderTableViewCellViewModel) {
        imageIdentifier = viewModel.imageIdentifier
        descriptionLabel.text = viewModel.description
        statusLabel.text = viewModel.status
        statusLabel.textColor = viewModel.statusColor
        priceLabel.text = viewModel.price
        orderImageView.image = viewModel.defaultImage
    }
    
    func updateImage(_ image: UIImage, for identifier: String) {
        if identifier == imageIdentifier {
            orderImageView.image = image
        }
    }
    
    // MARK: Private methods
    private func setupSubviews() {
        setupImageView()
        setupPriceLabel()
        setupDescriptionStackView()
    }

    private func setupImageView() {
        orderImageView.translatesAutoresizingMaskIntoConstraints = false
        orderImageView.contentMode = .scaleAspectFit
        contentView.addSubview(orderImageView)
        
        orderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding).isActive = true
        orderImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        orderImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize).isActive = true
        orderImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize).isActive = true
    }

    private func setupDescriptionStackView() {
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.axis = .vertical
        contentView.addSubview(descriptionStackView)
        
        descriptionStackView.leadingAnchor.constraint(equalTo: orderImageView.trailingAnchor, constant: Constants.padding).isActive = true
        descriptionStackView.topAnchor.constraint(equalTo: orderImageView.topAnchor).isActive = true
        descriptionStackView.bottomAnchor.constraint(equalTo: orderImageView.bottomAnchor).isActive = true
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.addArrangedSubview(descriptionLabel)
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.addArrangedSubview(statusLabel)
    }
    
    private func setupPriceLabel() {
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)

        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
