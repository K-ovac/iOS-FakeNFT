//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    
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
            placeholderImageView.widthAnchor.constraint(equalToConstant: 278),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 278),
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
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 20),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func setupBackToCartButton() {
        view.addSubview(backToCartButton)
        
        backToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        backToCartButton.addTarget(self, action: #selector(didTapBackToCartButton), for: .touchUpInside)
        backToCartButton.setTitle(NSLocalizedString("payment.success.button.title", comment: ""), for: .normal) 
        backToCartButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        backToCartButton.setTitleColor(.systemBackground, for: .normal)
        backToCartButton.layer.cornerRadius = 16
        backToCartButton.layer.masksToBounds = true
        backToCartButton.backgroundColor = .Button
        
        NSLayoutConstraint.activate([
            backToCartButton.heightAnchor.constraint(equalToConstant: 60),
            backToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
