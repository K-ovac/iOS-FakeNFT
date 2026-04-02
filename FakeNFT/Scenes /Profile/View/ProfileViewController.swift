//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ProfileViewModelProtocol
    private var isViewReady = false
    
    // MARK: - UI Elements
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .caption1
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(websiteTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    // MARK: - Section Headers
    private lazy var myNFTsHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = NSLocalizedString("Profile.myNft", comment: "")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()
    
    private lazy var favoritesHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = NSLocalizedString("Profile.favorites", comment: "")
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .textPrimary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return view
    }()
    
    private lazy var myNFTsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(myNFTsTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.isUserInteractionEnabled = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("Profile.myNft", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        countLabel.textColor = .textPrimary
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(countLabel)
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .black
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: button.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            countLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.myNFTsTitleLabel = titleLabel
        self.myNFTsCountLabel = countLabel
        
        return button
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(favoritesTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.isUserInteractionEnabled = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(containerView)
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("Profile.favorites", comment: "")
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        let countLabel = UILabel()
        countLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        countLabel.textColor = .textPrimary
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(countLabel)
        
        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .black
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: button.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            countLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.favoritesTitleLabel = titleLabel
        self.favoritesCountLabel = countLabel
        
        return button
    }()
    
    private weak var myNFTsTitleLabel: UILabel?
    private weak var myNFTsCountLabel: UILabel?
    private weak var favoritesTitleLabel: UILabel?
    private weak var favoritesCountLabel: UILabel?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("📱 ProfileViewController init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("📱 ProfileViewController viewDidLoad")
        setupUI()
        setupNavigationBar()
        bindViewModel()
        isViewReady = true
        viewModel.fetchProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("📱 ProfileViewController viewDidAppear")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProfile()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(websiteButton)
        view.addSubview(myNFTsButton)
        view.addSubview(favoritesButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            myNFTsButton.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 40),
            myNFTsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myNFTsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myNFTsButton.heightAnchor.constraint(equalToConstant: 56),
            
            favoritesButton.topAnchor.constraint(equalTo: myNFTsButton.bottomAnchor, constant: 0),
            favoritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoritesButton.heightAnchor.constraint(equalToConstant: 56),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        
        let editButton = UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(editTapped)
        )
        editButton.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func bindViewModel() {
        viewModel.onDataChange = { [weak self] in
            print("📱 Data changed, updating UI")
            DispatchQueue.main.async {
                self?.updateUI()
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            print("📱 Loading state changed: \(isLoading)")
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            print("📱 Error received: \(errorMessage)")
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }
    
    private func updateUI() {
        guard let profile = viewModel.profile else { return }
        
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description ?? ""
        websiteButton.setTitle(profile.website, for: .normal)
        
        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "person.crop.circle.fill"))
        }
        
        myNFTsCountLabel?.text = "(\(viewModel.nftsCount))"
        favoritesCountLabel?.text = "(\(viewModel.likesCount))"
    }
    
    private func showError(message: String) {
        guard isViewReady, view.window != nil else {
            print("⚠️ Cannot show alert - view controller not ready")
            return
        }
        
        let alert = UIAlertController(
            title: NSLocalizedString("Error.title", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Error.repeat", comment: ""), style: .default) { [weak self] _ in
            self?.viewModel.fetchProfile()
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func editTapped() {
        viewModel.editProfile()
    }
    
    @objc private func websiteTapped() {
        viewModel.openWebsite()
    }
    
    @objc private func myNFTsTapped() {
        viewModel.showMyNFTs()
    }
    
    @objc private func favoritesTapped() {
        viewModel.showFavorites()
    }
}
