//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 26.03.2026.
//

import UIKit
import Kingfisher

final class MyNFTTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
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
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableKeys.priceTitle
        label.font = .caption1
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableKeys.fromAuthor
        label.font = .caption1
        label.textColor = .textSecondary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(nftImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(fromLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(priceTitleLabel)
        contentView.addSubview(priceValueLabel)
        
        NSLayoutConstraint.activate([
            // Изображение
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            // Название
            nameLabel.topAnchor.constraint(equalTo: nftImageView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            // Рейтинг
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            // Автор
            fromLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 8),
            fromLabel.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 12),
            
            authorLabel.centerYAnchor.constraint(equalTo: fromLabel.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor),
            
            // Цена
            priceTitleLabel.bottomAnchor.constraint(equalTo: priceValueLabel.topAnchor, constant: -2),
            priceTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            priceValueLabel.bottomAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -8),
            priceValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with nft: NFTDisplayModel) {
        nameLabel.text = nft.name
        authorLabel.text = nft.author
        priceValueLabel.text = "\(nft.price) ETH"
        
        if let url = nft.imageUrl {
            nftImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
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
}
