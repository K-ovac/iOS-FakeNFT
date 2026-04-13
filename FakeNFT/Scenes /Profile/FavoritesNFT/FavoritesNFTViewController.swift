//
//   FavoritesNFTViewController.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 29.03.2026.
//

import UIKit

final class FavoritesNFTViewController: UIViewController {
    
    private let viewModel: FavoritesNFTViewModelProtocol
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = (view.bounds.width - 48) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + 80)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoritesNFTCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesNFTCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableKeys.favoritesEmpty
        label.textAlignment = .center
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(viewModel: FavoritesNFTViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
        viewModel.fetchFavorites()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .background
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .navigationBarTint
    }
    
    private func updateColors() {
        view.backgroundColor = .background
        collectionView.backgroundColor = .background
        emptyLabel.textColor = .textPrimary
    }
    
    private func bindViewModel() {
        viewModel.onDataChange = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                let isEmpty = self?.viewModel.nfts.isEmpty ?? true
                self?.emptyLabel.isHidden = !isEmpty
                self?.collectionView.isHidden = isEmpty
            }
        }
        
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showError(message: errorMessage)
            }
        }
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(
            title: LocalizableKeys.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: LocalizableKeys.errorRepeat, style: .default) { [weak self] _ in
            self?.viewModel.fetchFavorites()
        })
        alert.addAction(UIAlertAction(title: LocalizableKeys.errorCancel, style: .cancel))
        present(alert, animated: true)
    }
    
    private func showRemoveConfirmation(for nftId: String, nftName: String) {
        let alert = UIAlertController(
            title: LocalizableKeys.favoritesRemoveConfirmationTitle,
            message: LocalizableKeys.favoritesRemoveConfirmationMessage(with: nftName),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: LocalizableKeys.favoritesRemove, style: .destructive) { [weak self] _ in
            self?.viewModel.removeFromFavorites(nftId: nftId)
        })
        
        alert.addAction(UIAlertAction(title: LocalizableKeys.favoritesCancel, style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesNFTViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesNFTCollectionViewCell.reuseIdentifier, for: indexPath) as? FavoritesNFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let nft = viewModel.nfts[indexPath.row]
        cell.configure(with: nft, delegate: self)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesNFTViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected NFT: \(viewModel.nfts[indexPath.row].name)")
    }
}

// MARK: - FavoritesNFTCollectionViewCellDelegate
extension FavoritesNFTViewController: FavoritesNFTCollectionViewCellDelegate {
    func didTapRemoveFromFavorites(nftId: String) {
        if let nft = viewModel.nfts.first(where: { $0.id == nftId }) {
            showRemoveConfirmation(for: nftId, nftName: nft.name)
        }
    }
}
