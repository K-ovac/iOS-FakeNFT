//
//  DeleteConfirmationViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 05.04.2026.
//

import UIKit

final class DeleteConfirmationViewController: UIViewController {
    
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
        imageView.layer.cornerRadius = 12
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 108),
            imageView.heightAnchor.constraint(equalToConstant: 108)
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
            titleLabel.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 97)
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
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        deleteButton.setTitle(NSLocalizedString("deleteConfirmation.deleteButton.title", comment: ""), for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        deleteButton.backgroundColor = .Button
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = 12
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            deleteButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            
            cancelButton.leadingAnchor.constraint(equalTo: deleteButton.trailingAnchor, constant: 8),
            cancelButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
        ])
    }
}
