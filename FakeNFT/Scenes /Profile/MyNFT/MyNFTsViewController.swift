//
//  MyNFTsViewController.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 26.03.2026.
//

import UIKit
import Kingfisher

final class MyNFTsViewController: UIViewController {
    
    private let viewModel: MyNFTsViewModelProtocol
    
    // MARK: - UI Elements
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyNFTTableViewCell.self, forCellReuseIdentifier: "MyNFTTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizableKeys.myNftsEmpty
        label.textAlignment = .center
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(nftIds: [String]) {
        self.viewModel = MyNFTsViewModel(nftIds: nftIds)
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
        viewModel.fetchNFTs()
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
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.arrow.down"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
        sortButton.tintColor = .navigationBarTint
        navigationItem.rightBarButtonItem = sortButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .navigationBarTint
    }
    
    private func updateColors() {
        view.backgroundColor = .background
        tableView.backgroundColor = .background
        emptyLabel.textColor = .textPrimary
    }
    
    private func bindViewModel() {
        viewModel.onDataChange = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                let isEmpty = self?.viewModel.nfts.isEmpty ?? true
                self?.emptyLabel.isHidden = !isEmpty
                self?.tableView.isHidden = isEmpty
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
            self?.viewModel.fetchNFTs()
        })
        alert.addAction(UIAlertAction(title: LocalizableKeys.errorCancel, style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func sortTapped() {
        let alert = UIAlertController(
            title: LocalizableKeys.sortTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: LocalizableKeys.sortByPrice, style: .default) { [weak self] _ in
            self?.viewModel.sortByPrice()
        })
        
        alert.addAction(UIAlertAction(title: LocalizableKeys.sortByRating, style: .default) { [weak self] _ in
            self?.viewModel.sortByRating()
        })
        
        alert.addAction(UIAlertAction(title: LocalizableKeys.sortByName, style: .default) { [weak self] _ in
            self?.viewModel.sortByName()
        })
        
        alert.addAction(UIAlertAction(title: LocalizableKeys.sortCancel, style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyNFTsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.nfts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyNFTTableViewCell", for: indexPath) as? MyNFTTableViewCell else {
            return UITableViewCell()
        }
        
        let nft = viewModel.nfts[indexPath.row]
        cell.configure(with: nft)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNFTsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
