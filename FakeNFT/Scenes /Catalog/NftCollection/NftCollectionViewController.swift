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
    private var nftsCollectionViewHeightConstraint: NSLayoutConstraint?
    
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
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryForeground
        refreshControl.attributedTitle = NSAttributedString(
            string: NSLocalizedString("RefreshControl.title", comment: "")
        )
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - Init
    
    init(catalog: Catalog, servicesAssembly: ServicesAssembly) {
        self.catalog = catalog
        self.nftCollectionViewModel = NftCollectionViewModel(
            nftCollectionService: servicesAssembly.collectionsService,
            nftCollectionId: catalog.id,
            profileService: servicesAssembly.profileService
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
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
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        
        scrollView.addSubview(contentView)
        
        [nftImageView, nftNameLabel, authorLabel,
         authorLinkButton, descriptionLabel, nftsCollectionView].forEach {
            contentView.addSubview($0)
            $0.isHidden = true
        }
        
        configureNftsCollectionView()
        setupLayout()
        scrollView.refreshControl = refreshControl
    }
    
    private func uiVisibility() {
        [nftImageView, nftNameLabel, authorLabel, authorLinkButton, descriptionLabel, nftsCollectionView].forEach {
            $0.isHidden = false
        }
    }
    
    // MARK: - Setup LAyout
    
    private func setupLayout() {
        [scrollView, contentView, nftImageView, nftNameLabel,
         authorLabel, authorLinkButton, descriptionLabel,
         loadingIndicator, nftsCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: Metrics.Sizes.nftCollectionImageHeight)
        ])
        
        NSLayoutConstraint.activate([
            nftNameLabel.leadingAnchor.constraint(equalTo: nftImageView.leadingAnchor, constant: Metrics.Spacing.spacing16),
            nftNameLabel.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: -Metrics.Spacing.spacing16),
            nftNameLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: Metrics.Spacing.spacing16),
        ])
        
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: nftNameLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: authorLinkButton.leadingAnchor, constant: -Metrics.Spacing.spacing4),
            authorLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: Metrics.Spacing.spacing13),
        ])
        
        NSLayoutConstraint.activate([
            authorLinkButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: Metrics.Spacing.spacing4),
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
        
        let heightConstraint = nftsCollectionView.heightAnchor.constraint(equalToConstant: Metrics.Sizes.size0)
        heightConstraint.isActive = true
        nftsCollectionViewHeightConstraint = heightConstraint
        
        NSLayoutConstraint.activate([
            nftsCollectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            nftsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
            self?.refreshControl.endRefreshing()
            self?.nftsCollectionView.reloadData()
            self?.nftsCollectionView.layoutIfNeeded()
            self?.nftsCollectionViewHeightConstraint?.constant = self?.nftsCollectionView.contentSize.height ?? Metrics.Sizes.size0
        }
        
        nftCollectionViewModel.onFavoritesUpdated = { [weak self] in
            UIBlockingProgressHUD.dismiss()
            self?.nftsCollectionView.reloadData()
        }
        
        nftCollectionViewModel.onCartUpdated = { [weak self] in
            UIBlockingProgressHUD.dismiss()
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
    
    @objc private func refreshData() {
        nftCollectionViewModel.fetchNftCollectionInfo()
        print("Обновлены данные NFT коллекции ", catalog.name)
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
        let padding: CGFloat = Metrics.Spacing.spacing16 + Metrics.Spacing.spacing16
        let spacing: CGFloat = Metrics.Spacing.spacing9 * Metrics.Spacing.spacing2
        let availableWidth = collectionView.frame.width - padding - spacing
        
        let width = floor(availableWidth / 3)
        
        return CGSize(width: width, height: Metrics.Sizes.nftCardHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: Metrics.Spacing.spacing24, left: Metrics.Spacing.spacing16, bottom: Metrics.Spacing.spacing0, right: Metrics.Spacing.spacing16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.Spacing.spacing8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Metrics.Spacing.spacing9
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
        cell.delegate = self
        cell.configure(
            with: nft,
            isLiked: nftCollectionViewModel.isLiked(nftId: nft.id),
            isInCart: nftCollectionViewModel.isInCart(nftId: nft.id)
        )
        
        return cell
    }
}

// MARK: - Extension NftCollectionViewController: UICollectionViewDelegate

extension NftCollectionViewController: NftCollectionCellDelegate {
    func didTapFavoritesButton(on cell: NftCollectionCell) {
        guard let indexPath = nftsCollectionView.indexPath(for: cell) else { return }
        let nft = nftCollectionViewModel.nfts[indexPath.row]
        
        UIBlockingProgressHUD.show()
        nftCollectionViewModel.toggleFavorite(nftId: nft.id)
    }
    
    func didTapCartButton(on cell: NftCollectionCell) {
        guard let indexPath = nftsCollectionView.indexPath(for: cell) else { return }
        let nft = nftCollectionViewModel.nfts[indexPath.row]
        
        UIBlockingProgressHUD.show()
        nftCollectionViewModel.toggleCart(nftId: nft.id)
    }
}
