//
//  DeleteConfirmationViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 05.04.2026.
//

import UIKit

final class DeleteConfirmationViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let imageTopInset: CGFloat = 244
        static let imageSize: CGFloat = 108
        static let cornerRadius: CGFloat = 12
        static let titleTopInset: CGFloat = 12
        static let titleHeight: CGFloat = 36
        static let titleLeadingInset: CGFloat = 97
        static let buttonsTopInset: CGFloat = 20
        static let buttonHeight: CGFloat = 44
        static let buttonWidth: CGFloat = 127
        static let buttonsSpacing: CGFloat = 8
        static let deleteButtonTrailingOffset: CGFloat = 4
    }
    
    // MARK: - Properties
    
    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    private let item: CartItem
    
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let deleteButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    // MARK: - Init
    
    init(item: CartItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupUI()
        configure()
    }

    // MARK: - Actions
    
    @objc
    private func didTapDeleteButton() {
        dismiss(animated: true) { [weak self] in
            self?.onConfirm?()
        }
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true) { [weak self] in
            self?.onCancel?()
        }
    }
    
    // MARK: - Configuration
    
    private func configure() {
        imageView.setImage(from: item.imageURL)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupBlurEffectView()
        setupImageView()
        setupTitleLabel()
        setupButtons()
    }
}

extension DeleteConfirmationViewController {
    private func setupBlurEffectView() {
        view.addSubview(blurView)
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.cornerRadius
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.imageTopInset),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize)
        ])
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = NSLocalizedString("deleteConfirmation.title", comment: "")
        titleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.titleHeight),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.titleTopInset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.titleLeadingInset)
        ])
    }
    
    private func setupButtons() {
        view.addSubview(cancelButton)
        view.addSubview(deleteButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.setTitle(NSLocalizedString("deleteConfirmation.cancelButton.title", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        cancelButton.backgroundColor = .Button
        cancelButton.setTitleColor(.systemBackground, for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = Constants.cornerRadius
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        deleteButton.setTitle(NSLocalizedString("deleteConfirmation.deleteButton.title", comment: ""), for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        deleteButton.backgroundColor = .Button
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = Constants.cornerRadius
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -Constants.deleteButtonTrailingOffset),
            deleteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.buttonsTopInset),
            deleteButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            deleteButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            
            cancelButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: Constants.buttonsSpacing),
            cancelButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.buttonsTopInset),
            cancelButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            cancelButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
        ])
    }
}
