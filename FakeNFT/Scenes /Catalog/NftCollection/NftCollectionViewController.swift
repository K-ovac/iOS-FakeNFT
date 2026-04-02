//
//  NftCollectionViewController.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 26.03.2026.
//
import UIKit
import Kingfisher

final class NftCollectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let catalog: Catalog
    private var nftCollectionViewModel: NftCollectionViewModel
    
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
        button.titleLabel?.font = .caption1
        button.contentVerticalAlignment = .bottom
        
        button.addTarget(self, action: #selector(authorLinkButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .primaryForeground
        
        return indicator
    }()
    
    private lazy var nftsCollectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        
        return collectionView
    }()
    
    // MARK: - Init
    
    init(catalog: Catalog, servicesAssembly: ServicesAssembly) {
        self.catalog = catalog
        self.nftCollectionViewModel = NftCollectionViewModel(
            nftCollectionService: servicesAssembly.collectionsService,
            nftCollectionId: catalog.id
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
        bindingViewModel()
        nftCollectionViewModel.fetchNftCollectionInfo()
    }
    
    // MARK: - Configure UI
    
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
        [nftImageView, nftNameLabel, authorLabel, authorLinkButton, descriptionLabel, nftsCollectionView].forEach {
            view.addSubview($0)
            $0.isHidden = true
        }
        view.addSubview(loadingIndicator)
        
        configureNftsCollectionView()
        setupLayout()
    }
    
    private func uiVisibility() {
        [nftImageView, nftNameLabel, authorLabel, authorLinkButton, descriptionLabel, nftsCollectionView].forEach {
            $0.isHidden = false
        }
    }
    
    // MARK: - Setup LAyout
    
    private func setupLayout() {
        [nftImageView, nftNameLabel, authorLabel, authorLinkButton, descriptionLabel, loadingIndicator, nftsCollectionView].forEach {
            ($0).translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: nftNameLabel.topAnchor, constant: -Metrics.Spacing.medium),
            nftImageView.heightAnchor.constraint(equalToConstant: Metrics.Sizes.nftCollectionImageHeight)
        ])
        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor, constant: Metrics.Spacing.medium),
            nftNameLabel.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -Metrics.Spacing.medium),
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: Metrics.Spacing.medium),
        ])
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: authorLinkButton.leadingAnchor, constant: -Metrics.Spacing.verySmall),
            authorLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: Metrics.Spacing.smallLarge),
        ])
        NSLayoutConstraint.activate([
            authorLinkButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: Metrics.Spacing.verySmall),
            authorLinkButton.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nftNameLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: Metrics.Spacing.spacing5)
        ])
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftsCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            nftsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNftsCollectionView() {
        nftsCollectionView.delegate = self
        nftsCollectionView.dataSource = self
        
        nftsCollectionView.register(
            NftCollectionCell.self,
            forCellWithReuseIdentifier: NftCollectionCell.reuseIdentifier
        )
        
        nftsCollectionView.reloadData()
    }
    
    // MARK: - Binding
    
    private func bindingViewModel() {
        nftCollectionViewModel.onNftCollectionFetched = { [weak self] in
            guard let collection = self?.nftCollectionViewModel.nftCollection else { return }
            
            self?.uiVisibility()
            self?.nftNameLabel.text = collection.name
            self?.authorLinkButton.setTitle(collection.author, for: .normal)
            self?.descriptionLabel.text = collection.description
            
            if let url = URL(string: collection.cover) {
                self?.nftImageView.kf.setImage(with: url)
            }
        }
        
        nftCollectionViewModel.onNftsFetched = { [weak self] in
            self?.nftsCollectionView.reloadData()
        }
        
        nftCollectionViewModel.onError = { [weak self] errorModel in
            self?.showError(errorModel)
        }
        nftCollectionViewModel.onLoadingStarted = { [weak self] in
            self?.showLoading()
        }
        nftCollectionViewModel.onLoadingStopped = { [weak self] in
            self?.hideLoading()
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func authorLinkButtonTapped() {
        let vc = AuthorWebViewController(url: AuthorWebRequestConstant.authorURL)
        navigationController?.pushViewController(vc, animated: true)
        print("Author \(catalog.author), website: \(catalog.website)")
    }
}

// MARK: Extension NftCollectionViewController: LoadingView

extension NftCollectionViewController: LoadingView {
    var activityIndicator: UIActivityIndicatorView {
        return loadingIndicator
    }
}

// MARK: Extension NftCollectionViewController: ErrorView

extension NftCollectionViewController: ErrorView { }

// MARK: - Extension NftCollectionViewController: UICollectionViewDelegateFlowLayout

extension NftCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 + 16
        let spacing: CGFloat = 9 * 2
        let availableWidth = collectionView.frame.width - padding - spacing
        
        let width = floor(availableWidth / 3)
        
        return CGSize(width: width, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
}

// MARK: - Extension NftCollectionViewController: UICollectionViewDataSource

extension NftCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nftCollectionViewModel.numberOfNfts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NftCollectionCell.reuseIdentifier, for: indexPath) as? NftCollectionCell else { return UICollectionViewCell() }
        
        let nft = nftCollectionViewModel.nft(at: indexPath.row)
        cell.configure(with: nft)
        
        return cell
    }
    
    
}

// MARK: - Extension NftCollectionViewController: UICollectionViewDelegate

extension NftCollectionViewController: UICollectionViewDelegate {
    
}
