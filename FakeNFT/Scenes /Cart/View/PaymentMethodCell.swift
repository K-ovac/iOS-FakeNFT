//
//  PaymentMethodCell.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import UIKit

final class PaymentMethodCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let paymentIdentifier = "PaymentMethodCell"
    
    private let currencyImageView = UIImageView()
    private let currencyTitleLabel = UILabel()
    private let currencyNameLabel = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Configuration
    
    func configure(with item: Currency) {
        currencyImageView.setImage(from: URL(string: item.image))
        currencyTitleLabel.text = item.title.replacingOccurrences(of: "_", with: " ")
        currencyNameLabel.text = item.name
    }
    
    func setSelected(_ isSelected: Bool) {
        layer.cornerRadius = isSelected ? 12 : 0
        layer.borderWidth = isSelected ? 1 : 0
        layer.borderColor = isSelected ? UIColor.label.cgColor : UIColor.clear.cgColor
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        contentView.backgroundColor = .bottomContainer
        setupCurrencyImageView()
        setupCurrencyTitleLabel()
        setupCurrencyNameLabel()
    }
}

private extension PaymentMethodCell {
    func setupCurrencyImageView() {
        contentView.addSubview(currencyImageView)
        currencyImageView.translatesAutoresizingMaskIntoConstraints = false
        
        currencyImageView.clipsToBounds = true
        currencyImageView.layer.cornerRadius = 6
        currencyImageView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            currencyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            currencyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupCurrencyTitleLabel() {
        contentView.addSubview(currencyTitleLabel)
        currencyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        NSLayoutConstraint.activate([
            currencyTitleLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            currencyTitleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setupCurrencyNameLabel() {
        contentView.addSubview(currencyNameLabel)
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        currencyNameLabel.textColor = .textCurrencyName
        
        NSLayoutConstraint.activate([
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            currencyNameLabel.topAnchor.constraint(equalTo: currencyTitleLabel.bottomAnchor),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

    
   
