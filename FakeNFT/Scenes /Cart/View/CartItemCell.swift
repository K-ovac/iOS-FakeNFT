//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 29.03.2026.
//
import UIKit

final class CartItemCell: UITableViewCell {
    
    // MARK: - Constants
    
    // MARK: - Constants
        
    private enum Constants {
        static let imageSize: CGFloat = 108
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let infoViewLeading: CGFloat = 20
        static let infoViewWidth: CGFloat = 76
        static let infoViewHeight: CGFloat = 92
        static let infoViewTopInset: CGFloat = 24
        static let deleteButtonSize: CGFloat = 40
        static let cornerRadius: CGFloat = 12
        static let ratingTopInset: CGFloat = 4
        static let priceTitleTopInset: CGFloat = 12
        static let priceTopInset: CGFloat = 2
        static let starSize: CGFloat = 12
        static let ratingSpacing: CGFloat = 2
    }
    
    // MARK: - Properties
    
    static let reuseIdentifier = "CartItemCell"
    
    private let cartItemInfoView = UIView()
    private let nftImageView = UIImageView()
    private let nameLabel = UILabel()
    private let ratingStackView = UIStackView()
    private var starImageViews: [UIImageView] = []
    private let deleteButton = UIButton(type: .system)
    private let priceLabel = UILabel()
    private let priceTitleLabel = UILabel()
    
    var onDeleteTap: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Configuration
    
    func configure(with item: CartItem) {
        nameLabel.text = item.name
        configureRating(item.rating)
        priceLabel.text = String(format: "%.2f ETH", item.price)
        nftImageView.setImage(from: item.imageURL)
    }
    
    private func configureRating(_ rating: Int) {
        for (index, imageView) in starImageViews.enumerated() {
            if index < rating {
                imageView.image = UIImage(systemName: "star.fill")
                imageView.tintColor = .yellow
            } else {
                imageView.image = UIImage(systemName: "star")
                imageView.tintColor = .emptyStar
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapDeleteButton() {
        onDeleteTap?()
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupNftImageView()
        setupCartItemInfoView()
        setupCartItemInfoViewLabels()
        setupCartItemInfoViewRating()
        setupDeleteButton()
    }
}

extension CartItemCell {
    private func setupNftImageView() {
        contentView.addSubview(nftImageView)
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nftImageView.contentMode = .scaleAspectFill
        nftImageView.layer.cornerRadius = Constants.cornerRadius
        nftImageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            nftImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalInset),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.horizontalInset),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.horizontalInset)
        ])
    }
    
    private func setupCartItemInfoViewLabels() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        priceTitleLabel.text = NSLocalizedString("cartCell.info.priceTitle", comment: "")
        priceTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        priceLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: cartItemInfoView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: cartItemInfoView.topAnchor),
            
            priceTitleLabel.leadingAnchor.constraint(equalTo: cartItemInfoView.leadingAnchor),
            priceTitleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: Constants.priceTitleTopInset),
            
            priceLabel.leadingAnchor.constraint(equalTo: cartItemInfoView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: Constants.priceTopInset),
        ])

    }
    
    private func setupCartItemInfoViewRating() {
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = Constants.ratingSpacing
        ratingStackView.alignment = .leading

        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: Constants.starSize).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: Constants.starSize).isActive = true
            
            starImageViews.append(imageView)
            ratingStackView.addArrangedSubview(imageView)
        }
        
        NSLayoutConstraint.activate([
            ratingStackView.leadingAnchor.constraint(equalTo: cartItemInfoView.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.ratingTopInset),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    private func setupCartItemInfoView() {
        contentView.addSubview(cartItemInfoView)
        cartItemInfoView.addSubview(nameLabel)
        cartItemInfoView.addSubview(priceLabel)
        cartItemInfoView.addSubview(priceTitleLabel)
        cartItemInfoView.addSubview(ratingStackView)
        
        cartItemInfoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cartItemInfoView.widthAnchor.constraint(equalToConstant: Constants.infoViewWidth),
            cartItemInfoView.heightAnchor.constraint(equalToConstant: Constants.infoViewHeight),
            cartItemInfoView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: Constants.infoViewLeading),
            cartItemInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.infoViewTopInset),
            cartItemInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.infoViewTopInset)
        ])
    }
    
    private func setupDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setImage(UIImage(resource: .cart), for: .normal)
        deleteButton.tintColor = .Button
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.deleteButtonSize),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.deleteButtonSize),
            deleteButton.centerYAnchor.constraint(equalTo: cartItemInfoView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalInset)
        ])
    }
    
}
