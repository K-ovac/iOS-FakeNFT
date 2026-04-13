//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    // MARK: - Properties
    
    private var catalogViewModel: CatalogViewModel
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - UI Components
    
    private lazy var catalogTableView = UITableView(frame: .zero, style: .plain)
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.tintColor = .primaryForeground
        
        return indicator
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .primaryForeground
        refreshControl.attributedTitle = NSAttributedString(
            string: LocalizableKeys.refreshControlTitle
        )
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - Init
    
    init(servicesAssembly: ServicesAssembly) {
        self.catalogViewModel = CatalogViewModel(
            collectionsService: servicesAssembly.collectionsService
        )
        self.servicesAssembly = servicesAssembly
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
        
        catalogViewModel.fetchNftCollections()
    }
    
    // MARK: - Configure UI
    private func configureNavBar() {
        let sortButton = UIBarButtonItem(
            image: Images.sort,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped))
        sortButton.tintColor = .primaryForeground
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func configureView() {
        view.backgroundColor = .background
        view.addSubview(catalogTableView)
        view.addSubview(loadingIndicator)
        
        setupLayout()
        configureCategoryTableView()
    }
    
    private func setupLayout() {
        [
            catalogTableView,
            loadingIndicator
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            catalogTableView.topAnchor.constraint(equalTo: view.topAnchor),
            catalogTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            catalogTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            catalogTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureCategoryTableView() {
        catalogTableView.backgroundColor = .clear
        catalogTableView.contentInset = UIEdgeInsets(top: Metrics.Spacing.spacing16, left: Metrics.Spacing.spacing0, bottom: Metrics.Spacing.spacing0, right: Metrics.Spacing.spacing0)
        catalogTableView.separatorStyle = .none
        
        catalogTableView.delegate = self
        catalogTableView.dataSource = self
        catalogTableView.register(
            CatalogCell.self,
            forCellReuseIdentifier: CatalogCell.reuseIdentifier
        )
        catalogTableView.refreshControl = refreshControl
        
        catalogTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func sortButtonTapped() {
        showSortAlert()
    }
    
    @objc private func refreshData() {
        catalogViewModel.fetchNftCollections()
        print("Обновлены данные таблицы каталога NFT")
    }
    
    // MARK: - Sort Alert
    
    private func showSortAlert() {
        let alert = UIAlertController(
            title: LocalizableKeys.catalogSortTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        let sortByNameAction = UIAlertAction(
            title: LocalizableKeys.catalogSortByName,
            style: .default
        ) { [weak self] _ in
            self?.catalogViewModel.sortByName()
        }
        let sortByRatingAction = UIAlertAction(
            title: LocalizableKeys.catalogSortByNftCount,
            style: .default
        ) { [weak self] _ in
            self?.catalogViewModel.sortByNftsCount()
        }
        let cancelAction = UIAlertAction(
            title: LocalizableKeys.catalogSortCancel,
            style: .cancel
        )
        
        alert.addAction(sortByNameAction)
        alert.addAction(sortByRatingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Binding
    private func bindingViewModel() {
        
        catalogViewModel.onFetchedNftCollection = { [weak self] in
            self?.catalogTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
        
        catalogViewModel.onSelectedNftCollection = { [weak self] catalog in
            guard let self else { return }
            
            let vc = NftCollectionViewController(catalog: catalog, servicesAssembly: self.servicesAssembly)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(
                vc, animated: true
            )
        }
        
        catalogViewModel.onError = { [weak self] errorModel in
            self?.showError(errorModel)
        }
        catalogViewModel.onLoadingStarted = { [weak self] in
            self?.showLoading()
        }
        catalogViewModel.onLoadingStopped = { [weak self] in
            self?.hideLoading()
        }
    }
}

// MARK: - Extension CatalogViewController: UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catalogViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogCell.reuseIdentifier, for: indexPath) as? CatalogCell else {
            return UITableViewCell()
        }
        let catalog = catalogViewModel.nftCollection(at: indexPath.row)
        cell.configure(with: catalog)
        
        return cell
    }
}

// MARK: - CatalogViewController: UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Metrics.Sizes.cellCatalogHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        catalogViewModel.selectNftCollection(at: indexPath.row)
    }
}

// MARK: - Extension CatalogViewController: LoadingView

extension CatalogViewController: LoadingView {
    var activityIndicator: UIActivityIndicatorView {
        return loadingIndicator
    }
}

// MARK: - Extension CatalogViewController: ErrorView

extension CatalogViewController: ErrorView { }
