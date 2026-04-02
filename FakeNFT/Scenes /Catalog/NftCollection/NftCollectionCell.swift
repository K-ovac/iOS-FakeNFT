//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 01.04.2026.
//

import UIKit
import Kingfisher

final class NftCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: NftCollectionCell.self)
    
    // MARK: - UI Components
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12   //value
        
        return imageView
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "inFavorites"), for: .normal) //delete
        button.tintColor = .white   //value
        
        return button
    }()
    
    private lazy var nftRatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "rate")   //delete
        
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold) // value
        label.textAlignment = .left
        label.textColor = .black    //value
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium) // value
        label.textColor = .black    //value
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addToCart"), for: .normal) //delete
        button.tintColor = .black   //value
        
        return button
    }()
    
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
        [nftImageView, favoritesButton, nftRatingImageView, nftNameLabel, nftPriceLabel, cartButton].forEach {
            contentView.addSubview($0)
        }
        
        setupLayout()
    }
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        [nftImageView, nftRatingImageView, nftNameLabel, nftPriceLabel, cartButton, favoritesButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108)  //value
        ])
        
        NSLayoutConstraint.activate([
            favoritesButton.topAnchor.constraint(equalTo: nftImageView.topAnchor), //value
            favoritesButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),   //value
            favoritesButton.heightAnchor.constraint(equalToConstant: 40),
            favoritesButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            nftRatingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),   //value
            nftRatingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftNameLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: 5),   //value
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.trailingAnchor.constraint(equalTo: cartButton.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),    //value
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor),    //value
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),    //value
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Setup Actions
    
    private func setupActions() {
        favoritesButton.addTarget(self, action: #selector(didTapFavoritesButton), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(didTapAddToCartButton), for: .touchUpInside)
    }
    
    // MARK: Actions
    
    @objc private func didTapFavoritesButton() {
        print("tapped")
    }
    
    @objc private func didTapAddToCartButton() {
        print("tapped")
    }
    
    // MARK: - Configure Cell
    
    func configure(with nftCard: NFT) {
        if let url = URL(string: nftCard.images[0]) {
            nftImageView.kf.setImage(with: url) { [weak self] _ in
                self?.setNeedsLayout()
            }
        }

        nftNameLabel.text = nftCard.name
        nftPriceLabel.text = String(nftCard.price) + " " + "ETH"
    }
}
