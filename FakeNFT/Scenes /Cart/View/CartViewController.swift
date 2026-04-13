//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 29.03.2026.
//

import UIKit
import ProgressHUD

final class CartViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: CartViewModelProtocol
    private let tableView = UITableView()
    private let summaryLabel = UILabel()
    private let countNFTLabel = UILabel()
    private let bottomContainerView = UIView()
    private let checkoutButton = UIButton(type: .system)
    private let sortButton = UIButton(type: .system)
    private let emptyStateView = UIView()
    private let emptyStateLabel = UILabel()
    
    private var items: [CartItem] = []
    
    // MARK: - Init
    
    init(viewModel: CartViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel.onItemsChanged = { [weak self] items in
            self?.items = items
            self?.tableView.reloadData()
        }
        
        viewModel.onSummaryChanged = { [weak self] summary in
            self?.countNFTLabel.text = "\(summary.itemsCount) NFT"
            self?.summaryLabel.text = "\(String(format: "%.2f", summary.totalPrice)) ETH" 
        }
        
        viewModel.onStateChanged = { [weak self] state in
            switch state {
            case .loading:
                ProgressHUD.show()
                self?.tableView.isHidden = true
                self?.bottomContainerView.isHidden = true
                self?.sortButton.isHidden = true
                self?.emptyStateView.isHidden = true
                print("loading")
            case .content:
                ProgressHUD.dismiss()
                self?.tableView.isHidden = false
                self?.bottomContainerView.isHidden = false
                self?.sortButton.isHidden = false
                self?.emptyStateView.isHidden = true
                print("content")
            case .empty:
                ProgressHUD.dismiss()
                self?.tableView.isHidden = true
                self?.bottomContainerView.isHidden = true
                self?.sortButton.isHidden = true
                self?.emptyStateView.isHidden = false
                print("empty")
            case .error(let message):
                ProgressHUD.dismiss()
                print(message)
            }
        }
    
        viewModel.onShowDeleteConfirmation = { [weak self] item in
            self?.showDeleteConfirmation(for: item)
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapSortButton() {
        let alert = UIAlertController(title: NSLocalizedString("cart.sortAlert.title", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        CartSortOption.allCases.forEach { option in
            alert.addAction(UIAlertAction(title: option.title, style: .default) { [weak self] _ in
                self?.viewModel.didSelectSort(option)
            })
        }

        alert.addAction(UIAlertAction(title: NSLocalizedString("cart.sortAlert.cancel", comment: ""), style: .cancel))
        present(alert, animated: true)
    }
    
    @objc
    private func didTapCheckoutButton() {
        let currenciesService = CurrenciesService(networkClient: DefaultNetworkClient())
        let paymentService = PaymentService(networkClient: DefaultNetworkClient())
        let completeOrderService = CompleteOrderService(networkClient: DefaultNetworkClient())
        let clearCartService = ClearCartService()
        
        let viewModel = PaymentMethodsViewModel(
            currenciesService: currenciesService,
            paymentService: paymentService,
            completeOrderService: completeOrderService,
            clearCartService: clearCartService
        )
        
        let viewController = PaymentMethodsViewController(viewModel: viewModel)
        viewController.onPaymentFlowFinished = { [weak self] in
            self?.viewModel.refresh()
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
            
        present(navigationController, animated: true)
    }
    
    // MARK: - Navigation
    
    private func showDeleteConfirmation(for item: CartItem) {
        let vc = DeleteConfirmationViewController(item: item)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve

        vc.onConfirm = { [weak self] in
            self?.viewModel.confirmDelete()
        }

        vc.onCancel = {
            print("Delete cancelled")
        }
        
        present(vc, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupSortButton()
        setupBottomContainerView()
        setupTableView()
        setupEmptyStateView()
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.reuseIdentifier, for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item)
        cell.onDeleteTap = { [weak self] in
            self?.viewModel.didTapDelete(for: item)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

//TODO:
extension CartViewController: UITableViewDelegate {
    
}

// MARK: - Setup

extension CartViewController {
    private func setupSortButton() {
        view.addSubview(sortButton)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        sortButton.setImage(UIImage(resource: .sort), for: .normal)
        sortButton.tintColor = .Button
        
        sortButton.addTarget(self, action: #selector(didTapSortButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            sortButton.heightAnchor.constraint(equalToConstant: 42),
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.rowHeight = 140
        
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor)
        ])
    }
    
    private func setupBottomContainerView() {
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(checkoutButton)
        bottomContainerView.addSubview(summaryLabel)
        bottomContainerView.addSubview(countNFTLabel)
        
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        countNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        
        checkoutButton.setTitle(NSLocalizedString("cart.checkoutButton.title", comment: ""), for: .normal)
        checkoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        checkoutButton.layer.cornerRadius = 16
        checkoutButton.clipsToBounds = true
        checkoutButton.backgroundColor = .Button
        checkoutButton.setTitleColor(.systemBackground, for: .normal)
        checkoutButton.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
        
        summaryLabel.text = "5,34 ETH"
        summaryLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        summaryLabel.textColor = .systemGreen
        
        countNFTLabel.text = "3 NFT"
        countNFTLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        bottomContainerView.backgroundColor = .bottomContainer
        bottomContainerView.layer.cornerRadius = 16
        bottomContainerView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 76),
            
            checkoutButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            checkoutButton.heightAnchor.constraint(equalToConstant: 44),
            checkoutButton.leadingAnchor.constraint(equalTo: summaryLabel.trailingAnchor, constant: 24),
            
            countNFTLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            countNFTLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            countNFTLabel.heightAnchor.constraint(equalToConstant: 20),
            
            summaryLabel.topAnchor.constraint(equalTo: countNFTLabel.bottomAnchor, constant: 2),
            summaryLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupEmptyStateView() {
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateLabel)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateLabel.text = NSLocalizedString("cart.emptyState.text", comment: "")
        emptyStateLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        NSLayoutConstraint.activate([
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.heightAnchor.constraint(equalToConstant: 22),
            
            emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor)
        ])
    }
    
   
}
