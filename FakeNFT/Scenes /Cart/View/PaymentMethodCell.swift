//
//  PaymentMethodCell.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import UIKit

final class PaymentMethodCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let contentCornerRadius: CGFloat = 12
        static let imageSize: CGFloat = 36
        static let imageLeadingInset: CGFloat = 12
        static let imageCornerRadius: CGFloat = 6
        static let labelsLeadingInset: CGFloat = 4
        static let titleTopInset: CGFloat = 5
        static let labelHeight: CGFloat = 18
        static let selectedBorderWidth: CGFloat = 1
    }
    
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
        layer.cornerRadius = isSelected ? Constants.contentCornerRadius : 0
        layer.borderWidth = isSelected ? Constants.selectedBorderWidth : 0
        layer.borderColor = isSelected ? UIColor.label.cgColor : UIColor.clear.cgColor
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.layer.cornerRadius = Constants.contentCornerRadius
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
        currencyImageView.layer.cornerRadius = Constants.imageCornerRadius
        currencyImageView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            currencyImageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            currencyImageView.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            currencyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.imageLeadingInset),
            currencyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupCurrencyTitleLabel() {
        contentView.addSubview(currencyTitleLabel)
        currencyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyTitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        
        NSLayoutConstraint.activate([
            currencyTitleLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: Constants.labelsLeadingInset),
            currencyTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.titleTopInset),
            currencyTitleLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])
    }
    
    func setupCurrencyNameLabel() {
        contentView.addSubview(currencyNameLabel)
        currencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        currencyNameLabel.textColor = .textCurrencyName
        
        NSLayoutConstraint.activate([
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: Constants.labelsLeadingInset),
            currencyNameLabel.topAnchor.constraint(equalTo: currencyTitleLabel.bottomAnchor),
            currencyNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

    
   
