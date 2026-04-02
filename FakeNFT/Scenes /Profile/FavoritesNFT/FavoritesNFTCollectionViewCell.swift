//
//  FavoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 29.03.2026.
//

import UIKit
import Kingfisher

protocol FavoritesNFTCollectionViewCellDelegate: AnyObject {
    func didTapRemoveFromFavorites(nftId: String)
}

final class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FavoritesNFTCollectionViewCell"
    
    // MARK: - UI Elements
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .caption1
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var currentNFTId: String?
    weak var delegate: FavoritesNFTCollectionViewCellDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            // Изображение
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            // Кнопка лайка
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            // Название
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Рейтинг
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            // Цена
            priceTitleLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 8),
            priceTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configuration
    func configure(with nft: FavoritesNFTDisplayModel, delegate: FavoritesNFTCollectionViewCellDelegate?) {
        self.currentNFTId = nft.id
        self.delegate = delegate
        
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        
        if let url = nft.imageUrl {
            imageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        }
        
        setupRating(rating: nft.rating)
    }
    
    private func setupRating(rating: Int) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            if i < rating {
                starImageView.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                starImageView.tintColor = .systemYellow
            } else {
                starImageView.image = UIImage(systemName: "star")
                starImageView.tintColor = .lightGray
            }
            
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    // MARK: - Actions
    @objc private func likeButtonTapped() {
        guard let nftId = currentNFTId else { return }
        delegate?.didTapRemoveFromFavorites(nftId: nftId)
    }
}
