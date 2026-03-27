//
//  NftCollectionViewController.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 26.03.2026.
//
import UIKit

final class NftCollectionViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var nftImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Metrics.CornerRadius.medium
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return imageView
    }()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.text = NSLocalizedString("Collection.author", comment: "static label")
        
        return label
    }()
    
    private lazy var authorLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.setTitleColor(.link, for: .normal)
        
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.numberOfLines = 10
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
    }
    
    private func configureNavBar() {
        let backButton = UIBarButtonItem(
            image: Images.back,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        backButton.tintColor = .primaryForeground
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureView() {
        view.backgroundColor = .background
        [nftImageView, nftNameLabel, authorLabel, authorLinkButton, descriptionLabel].forEach {
            view.addSubview($0)
        }
        
        setupLayout()
    }
    
    private func setupLayout() {
        [nftImageView, nftNameLabel, authorLabel, authorLinkButton, descriptionLabel].forEach {
            ($0).translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: nftNameLabel.topAnchor, constant: -Metrics.Spacing.medium)
        ])
        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor, constant: Metrics.Spacing.medium),
            nftNameLabel.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -Metrics.Spacing.medium),
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: -Metrics.Spacing.medium),
        ])
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor, constant: Metrics.Spacing.medium),
            authorLabel.trailingAnchor.constraint(equalTo: authorLinkButton.leadingAnchor, constant: -Metrics.Spacing.verySmall),
            authorLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 13), //value
        ])
        NSLayoutConstraint.activate([
            authorLinkButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: Metrics.Spacing.verySmall),
            authorLinkButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
