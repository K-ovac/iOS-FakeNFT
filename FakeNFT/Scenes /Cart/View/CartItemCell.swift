//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 29.03.2026.
//
import UIKit

final class CartItemCell: UITableViewCell {
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
    
    private func setupUI() {
        setupNftImageView()
        setupCartItemInfoView()
        setupCartItemInfoViewLabels()
        setupCartItemInfoViewRating()
        setupDeleteButton()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func configure(with item: CartItem) {
        nameLabel.text = item.name
        configureRating(item.rating)
        priceLabel.text = "\(item.price) ETH"
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapDeleteButton() {
        onDeleteTap?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nftImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
    }
}

extension CartItemCell {
    private func setupNftImageView() {
        contentView.addSubview(nftImageView)
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nftImageView.contentMode = .scaleAspectFill
        nftImageView.layer.cornerRadius = 12
        nftImageView.clipsToBounds = true
        nftImageView.backgroundColor = .systemGray
        
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
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
            priceTitleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: cartItemInfoView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
        ])

    }
    
    private func setupCartItemInfoViewRating() {
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        
        ratingStackView.axis = .horizontal
        ratingStackView.spacing = 2
        ratingStackView.alignment = .leading

        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            starImageViews.append(imageView)
            ratingStackView.addArrangedSubview(imageView)
        }
        
        NSLayoutConstraint.activate([
            ratingStackView.leadingAnchor.constraint(equalTo: cartItemInfoView.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
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
            cartItemInfoView.widthAnchor.constraint(equalToConstant: 76),
            cartItemInfoView.heightAnchor.constraint(equalToConstant: 92),
            cartItemInfoView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            cartItemInfoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            cartItemInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.setImage(UIImage(resource: .cart), for: .normal)
        deleteButton.tintColor = .Button
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.centerYAnchor.constraint(equalTo: cartItemInfoView.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
}
