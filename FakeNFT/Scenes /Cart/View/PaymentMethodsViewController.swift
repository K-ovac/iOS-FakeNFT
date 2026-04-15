//
//  PaymentMethodsViewController.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import UIKit
import ProgressHUD

final class PaymentMethodsViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let collectionTopInset: CGFloat = 20
        static let layoutSpacing: CGFloat = 7
        static let sectionInset: CGFloat = 16
        static let itemHeight: CGFloat = 46
        static let bottomContainerHeight: CGFloat = 186
        static let bottomContainerCornerRadius: CGFloat = 12
        static let horizontalInset: CGFloat = 16
        static let agreementTopInset: CGFloat = 16
        static let agreementSpacing: CGFloat = 4
        static let payButtonTopInset: CGFloat = 16
        static let payButtonWidth: CGFloat = 343
        static let payButtonHeight: CGFloat = 60
        static let payButtonCornerRadius: CGFloat = 16
    }
    
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
            
        let layout = Self.setupLayout()
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
    
    // MARK: - Navigation
    
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
    
    private static func setupLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.layoutSpacing
        layout.minimumInteritemSpacing = Constants.layoutSpacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sectionInset, bottom: 0, right: Constants.sectionInset)
        return layout
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
        let horizontalInsets: CGFloat = Constants.horizontalInset * 2
        let spacing: CGFloat = Constants.layoutSpacing
        let width = (collectionView.bounds.width - horizontalInsets - spacing) / 2
        return CGSize(width: width, height: Constants.itemHeight)
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionTopInset),
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
            agreementTitleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: Constants.horizontalInset),
            agreementTitleLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: Constants.agreementTopInset),
            
            agreementButton.leadingAnchor.constraint(equalTo: agreementTitleLabel.leadingAnchor),
            agreementButton.topAnchor.constraint(equalTo: agreementTitleLabel.bottomAnchor, constant: Constants.agreementSpacing),
        ])
    }
    
    func setupPayButton() {
        payButton.setTitle(NSLocalizedString("payment.payButton.title", comment: ""), for: .normal)
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        payButton.backgroundColor = .Button
        payButton.layer.cornerRadius = Constants.payButtonCornerRadius
        payButton.layer.masksToBounds = true
        payButton.setTitleColor(.systemBackground, for: .normal)
        payButton.addTarget(self, action: #selector(didTapPayButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            payButton.widthAnchor.constraint(equalToConstant: Constants.payButtonWidth),
            payButton.heightAnchor.constraint(equalToConstant: Constants.payButtonHeight),
            payButton.centerXAnchor.constraint(equalTo: bottomContainerView.centerXAnchor),
            payButton.topAnchor.constraint(equalTo: agreementButton.bottomAnchor, constant: Constants.payButtonTopInset)
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
        
        bottomContainerView.layer.cornerRadius = Constants.bottomContainerCornerRadius
        bottomContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomContainerView.layer.masksToBounds = true
        bottomContainerView.backgroundColor = .bottomContainer
        
        NSLayoutConstraint.activate([
            bottomContainerView.heightAnchor.constraint(equalToConstant: Constants.bottomContainerHeight),
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


