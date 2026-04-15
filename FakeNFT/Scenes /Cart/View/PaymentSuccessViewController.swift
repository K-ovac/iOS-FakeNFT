//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let placeholderImageSize: CGFloat = 278
        static let titleTopInset: CGFloat = 20
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 16
        static let buttonHeight: CGFloat = 60
        static let buttonCornerRadius: CGFloat = 16
    }
    
    // MARK: - Properties
    
    var onDone: (() -> Void)?
    
    private let placeholderImageView = UIImageView()
    private let placeholderLabel = UILabel()
    private let backToCartButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        setupUI()
    }
    
    // MARK: - Actions
        
    @objc
    private func didTapBackToCartButton() {
        onDone?()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupPlaceholderImageView()
        setupPlaceholderLabel()
        setupBackToCartButton()
    }
}

private extension PaymentSuccessViewController {
    func setupPlaceholderImageView() {
        view.addSubview(placeholderImageView)
        
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderImageView.image = UIImage(resource: .successfulPayment)
        
        NSLayoutConstraint.activate([
            placeholderImageView.widthAnchor.constraint(equalToConstant: Constants.placeholderImageSize),
            placeholderImageView.heightAnchor.constraint(equalToConstant: Constants.placeholderImageSize),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupPlaceholderLabel() {
        view.addSubview(placeholderLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderLabel.text = NSLocalizedString("payment.success.title", comment: "")
        placeholderLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        placeholderLabel.numberOfLines = 2
        placeholderLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: Constants.titleTopInset),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
        ])
    }
    
    func setupBackToCartButton() {
        view.addSubview(backToCartButton)
        
        backToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        backToCartButton.addTarget(self, action: #selector(didTapBackToCartButton), for: .touchUpInside)
        backToCartButton.setTitle(NSLocalizedString("payment.success.button.title", comment: ""), for: .normal) 
        backToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        backToCartButton.setTitleColor(.systemBackground, for: .normal)
        backToCartButton.layer.cornerRadius = Constants.buttonCornerRadius
        backToCartButton.layer.masksToBounds = true
        backToCartButton.backgroundColor = .Button
        
        NSLayoutConstraint.activate([
            backToCartButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            backToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalInset),
            backToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalInset),
            backToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.verticalInset)
        ])
    }
}
