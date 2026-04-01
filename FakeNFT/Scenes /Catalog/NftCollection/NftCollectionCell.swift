//
//  NftCollectionCell.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 01.04.2026.
//

import UIKit

final class NftCollectionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: NftCollectionCell.self)
    
    // MARK: - UI Components
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12   //value
        imageView.image = UIImage(named: "image")   //delete
        
        return imageView
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "favor"), for: .normal) //delete
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
        label.text = "Mamie" //delete
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold) // value
        label.textColor = .black    //value
        
        return label
    }()
    
    private lazy var nftPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "31.64 ETH" //delete
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium) // value
        label.textColor = .black    //value
        
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart"), for: .normal) //delete
        button.tintColor = .black   //value
        
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func configureView() {
        contentView.backgroundColor = .clear
        [nftImageView, nftRatingImageView, nftNameLabel, nftPriceLabel, cartButton].forEach {
            contentView.addSubview($0)
        }
        nftImageView.addSubview(favoritesButton)
        
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
            favoritesButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11), //value
            favoritesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)   //value
        ])
        
        NSLayoutConstraint.activate([
            nftRatingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),   //value
            nftRatingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftNameLabel.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: 5),   //value
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftPriceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),    //value
            nftPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cartButton.topAnchor.constraint(equalTo: nftRatingImageView.bottomAnchor, constant: 15),    //value
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)    //value
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
    
//    func configure(with nftCard: NFT) {
//        if let url = URL(string: NFT.cover) {
//            nftImageView.kf.setImage(with: url) [weak self] _ {
//                self?.setNeedsLayout()
//            }
//        }
//
//        nftNameLabel.text = nftCard.name
//        nftPriceLabel.text = nftCard.price + "ETH"
//    }
}
