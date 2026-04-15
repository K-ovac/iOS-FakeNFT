//
//  PaymentMethodsViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import UIKit
import ProgressHUD

final class PaymentMethodsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel: PaymentMethodsViewModelProtocol
    
    var onPaymentFlowFinished: (() -> Void)?
    
    private let payButton = UIButton(type: .system)
    private let collectionView: UICollectionView
    private let agreementButton = UIButton(type: .system)
    private let bottomContainerView = UIView()
    private let agreementTitleLabel = UILabel()
    
    private var items: [Currency] = []
    
    // MARK: - Init
    
    init(viewModel: PaymentMethodsViewModelProtocol) {
        self.viewModel = viewModel
            
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.minimumInteritemSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = NSLocalizedString("payment.title", comment: "")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(didTapBackButton)
        )
            
        setupUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    // MARK: - Bindings
    
    private func bindViewModel() {
        viewModel.onItemsChanged = { [weak self] items in
            self?.items = items
            self?.collectionView.reloadData()
        }
            
        viewModel.onLoadingStateChanged = { isLoading in
            if isLoading {
                ProgressHUD.show()
            } else {
                ProgressHUD.dismiss()
            }
        }
            
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(
                title: NSLocalizedString("alert.error", comment: ""),
                message: message,
                preferredStyle: .alert
            )
                
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert.ok", comment: ""), style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.onPayButtonStateChanged = { [weak self] isEnabled in
            self?.payButton.isEnabled = isEnabled
            self?.payButton.alpha = isEnabled ? 1.0 : 0.5
        }
        
        viewModel.onOpenAgreement = { [weak self] url in
            self?.showAgreement(url: url)
        }
        
        viewModel.onPaymentSuccess = { [weak self] in
            self?.showPaymentSuccess()
        }
        
        viewModel.onPaymentError = { [weak self] message in
            self?.showPaymentErrorAlert(message: message)
        }
    }
    
    //MARK: - Actions
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapAgreementButton() {
        viewModel.didTapAgreement()
    }
    
    @objc
    private func didTapPayButton() {
        viewModel.didTapPay()
    }
    
    // MARK: -
    
    private func showAgreement(url: URL) {
        let viewController = AgreementViewController(url: url)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showPaymentErrorAlert(message: String) {
        let alert = UIAlertController(
            title: NSLocalizedString("payment.errorAlert.title", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("payment.errorAlert.cancel", comment: ""), style: .cancel))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("payment.errorAlert.repeat", comment: ""), style: .default) { [weak self] _ in
            self?.viewModel.didTapPay()
        })
        
        present(alert, animated: true)
    }
    
    private func showPaymentSuccess() {
        let viewController = PaymentSuccessViewController()
        
        viewController.onDone = { [weak self] in
            self?.finishPaymentFlow()
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func finishPaymentFlow() {
        onPaymentFlowFinished?()
        dismiss(animated: true)
    }
    
    //MARK: - Setup
    
    private func setupUI() {
        setupBottomContainerView()
        setupAgreement()
        setupPayButton()
        setupCollectionView()
    }
}

// MARK: - UICollectionViewDataSource

extension PaymentMethodsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PaymentMethodCell.paymentIdentifier, for: indexPath) as? PaymentMethodCell else {
            return UICollectionViewCell()
        }
                
        let item = items[indexPath.item]
        cell.configure(with: item)
        cell.setSelected(viewModel.isCurrencySelected(at: indexPath.item))
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PaymentMethodsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let horizontalInsets: CGFloat = 16 * 2
        let spacing: CGFloat = 7
        let width = (collectionView.bounds.width - horizontalInsets - spacing) / 2
        return CGSize(width: width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCurrency(at: indexPath.item)
    }
}

//MARK: - Setup

private extension PaymentMethodsViewController {
    func setupCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(PaymentMethodCell.self, forCellWithReuseIdentifier: PaymentMethodCell.paymentIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor)
        ])
    }
    
    func setupAgreement() {
        agreementTitleLabel.text = NSLocalizedString("payment.agreement.title", comment: "")
        agreementTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        agreementButton.setTitle(NSLocalizedString("payment.agreementButton.title", comment: ""), for: .normal)
        agreementButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        agreementButton.addTarget(self, action: #selector(didTapAgreementButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            agreementTitleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            agreementTitleLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            
            agreementButton.leadingAnchor.constraint(equalTo: agreementTitleLabel.leadingAnchor),
            agreementButton.topAnchor.constraint(equalTo: agreementTitleLabel.bottomAnchor, constant: 4),
        ])
    }
    
    func setupPayButton() {
        payButton.setTitle(NSLocalizedString("payment.payButton.title", comment: ""), for: .normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        payButton.backgroundColor = .Button
        payButton.layer.cornerRadius = 16
        payButton.layer.masksToBounds = true
        payButton.setTitleColor(.systemBackground, for: .normal)
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            payButton.widthAnchor.constraint(equalToConstant: 343),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
            payButton.topAnchor.constraint(equalTo: agreementButton.bottomAnchor, constant: 16)
        ])
    }
    
    func setupBottomContainerView() {
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(agreementTitleLabel)
        bottomContainerView.addSubview(agreementButton)
        bottomContainerView.addSubview(payButton)
        
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        agreementTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        payButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainerView.layer.cornerRadius = 12
        bottomContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomContainerView.layer.masksToBounds = true
        bottomContainerView.backgroundColor = .bottomContainer
        
        NSLayoutConstraint.activate([
            bottomContainerView.heightAnchor.constraint(equalToConstant: 186),
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


