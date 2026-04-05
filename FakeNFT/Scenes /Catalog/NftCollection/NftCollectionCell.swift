//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 01.04.2026.
//

import UIKit
import Kingfisher

// MARK: - NftCollectionCellDelegate

protocol NftCollectionCellDelegate: AnyObject {
    func didTapFavoritesButton(on cell: NftCollectionCell)
    func didTapCartButton(on cell: NftCollectionCell)
}

// MARK: - NftCollectionCell

final class NftCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: NftCollectionCell.self)
    weak var delegate: NftCollectionCellDelegate?
    
    // MARK: - UI Components
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Metrics.CornerRadius.medium
        
        return imageView
    }()
    
    private lazy var nftRatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metrics.Spacing.spacing2
        stackView.backgroundColor = .clear
        
        return stackView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textAlignment = .left
        label.textColor = .textPrimary
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = .textPrimary
        
        return label
    }()
    
    private lazy var favoritesButton = UIButton()
    private lazy var cartButton = UIButton()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureView() {
        contentView.backgroundColor = .clear
        [nftImageView, favoritesButton, nftRatingStackView, nftNameLabel, nftPriceLabel, cartButton].forEach {
            contentView.addSubview($0)
        }
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        [nftImageView, favoritesButton, nftRatingStackView, nftNameLabel, nftPriceLabel, cartButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardImageHeight)
        ])
        
        NSLayoutConstraint.activate([
            favoritesButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            favoritesButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            favoritesButton.heightAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardButtonSize),
            favoritesButton.widthAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardButtonSize)
        ])
        
        NSLayoutConstraint.activate([
            nftRatingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: Metrics.Spacing.spacing8),
            nftRatingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftNameLabel.topAnchor.constraint(equalTo: nftRatingStackView.bottomAnchor, constant: Metrics.Spacing.spacing5),
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: Metrics.Spacing.spacing4),
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: nftRatingStackView.bottomAnchor),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardButtonSize),
            cartButton.widthAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardButtonSize)
        ])
    }
    
    // MARK: - Method for Nft Rating
    
    private func configureNftRatingStackView(with rating: Int) {
        let ratingRange = 0..<5
        
        nftRatingStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        for nftRating in ratingRange {
            let ratingImageView = UIImageView()
            ratingImageView.contentMode = .scaleAspectFill
            ratingImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                ratingImageView.widthAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardRatingSize),
                ratingImageView.heightAnchor.constraint(equalToConstant: Metrics.Sizes.nftCardRatingSize)
            ])
            
            if nftRating < rating {
                ratingImageView.image = Images.starFill
            } else {
                ratingImageView.image = Images.star
            }
            nftRatingStackView.addArrangedSubview(ratingImageView)
        }
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        favoritesButton.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(didTapAddToCartButton), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc private func didTapFavoritesButton() {
        print("Favotites tapped")
        delegate?.didTapFavoritesButton(on: self)
    }
    
    @objc private func didTapAddToCartButton() {
        print("Cart tapped")
        delegate?.didTapCartButton(on: self)
    }
    
    // MARK: - Configure Cell
    
    func configure(with nftCard: NFT, isLiked: Bool, isInCart: Bool) {
        if let url = URL(string: nftCard.images[0]) {
            nftImageView.kf.setImage(with: url) { [weak self] _ in
                self?.setNeedsLayout()
            }
        }

        nftNameLabel.text = nftCard.name
        nftPriceLabel.text = String(nftCard.price) + " " + "ETH"
        
        configureNftRatingStackView(with: nftCard.rating)
                
        let favoritesButtonImage = isLiked ? Images.inFavorites : Images.notInFavorites
        let cartButtonImage = isInCart ? Images.removeFromCart : Images.addToCart
        
        favoritesButton.setImage(favoritesButtonImage, for: .normal)
        cartButton.setImage(cartButtonImage, for: .normal)
    }
}
