//
//  PaymentMethodsViewModel.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import Foundation

protocol PaymentMethodsViewModelProtocol {
    var onItemsChanged: (([Currency]) -> Void)? { get set }
    var onLoadingStateChanged: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onPayButtonStateChanged: ((Bool) -> Void)? { get set }
    var onOpenAgreement: ((URL) -> Void)? { get set }
    var onPaymentSuccess: (() -> Void)? { get set }
    var onPaymentError: ((String) -> Void)? { get set }
    
    func viewDidLoad()
    func didSelectCurrency(at index: Int)
    func isCurrencySelected(at index: Int) -> Bool
    func didTapAgreement()
    func didTapPay()
}

final class PaymentMethodsViewModel: PaymentMethodsViewModelProtocol {
    
    // MARK: - Output
    
    var onItemsChanged: (([Currency]) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onPayButtonStateChanged: ((Bool) -> Void)?
    var onOpenAgreement: ((URL) -> Void)?
    var onPaymentSuccess: (() -> Void)?
    var onPaymentError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private let currenciesService: CurrenciesServiceProtocol
    private var items: [Currency] = []
    private var selectedCurrencyId: String?
    private let paymentService: PaymentServiceProtocol
    private let completeOrderService: CompleteOrderServiceProtocol
    private let clearCartService: ClearCartServiceProtocol
    
    // MARK: - Init
    
    init(
        currenciesService: CurrenciesServiceProtocol,
        paymentService: PaymentServiceProtocol,
        completeOrderService: CompleteOrderServiceProtocol,
        clearCartService: ClearCartServiceProtocol
    ) {
        self.currenciesService = currenciesService
        self.paymentService = paymentService
        self.completeOrderService = completeOrderService
        self.clearCartService = clearCartService
    }
    
    // MARK: - Input
    
    func viewDidLoad() {
        loadCurrencies()
    }
    
    // MARK: -
    
    func didSelectCurrency(at index: Int) {
        guard index < items.count else { return }
            
        selectedCurrencyId = items[index].id
        onItemsChanged?(items)
        onPayButtonStateChanged?(true)
    }
    
    func isCurrencySelected(at index: Int) -> Bool {
        guard index < items.count else { return false }
        return items[index].id == selectedCurrencyId
    }
    
    func didTapAgreement() {
        guard let url = URL(string: RequestConstants.userAgreementURL) else { return }
        onOpenAgreement?(url)
    }
    
    func didTapPay() {
        guard let selectedCurrencyId else { return }
        
        onLoadingStateChanged?(true)
        
        paymentService.pay(currencyId: selectedCurrencyId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                guard response.success else {
                    self.onLoadingStateChanged?(false)
                    self.onPaymentError?("Не удалось выполнить оплату")
                    return
                }
                
                self.completeOrderService.completeOrder { [weak self] completeResult in
                    guard let self else { return }
                    
                    switch completeResult {
                    case .success:
                        self.clearCartService.clearCart { [weak self] clearResult in
                            guard let self else { return }
                            
                            self.onLoadingStateChanged?(false)
                            
                            switch clearResult {
                            case .success:
                                self.onPaymentSuccess?()
                            case .failure(let error):
                                print("CLEAR CART ERROR:", error)
                                self.onPaymentError?("Не удалось очистить корзину после оплаты")
                            }
                        }
                        
                    case .failure(let error):
                        self.onLoadingStateChanged?(false)
                        print("COMPLETE ORDER ERROR:", error)
                        self.onPaymentError?("Не удалось завершить заказ")
                    }
                }
                
            case .failure(let error):
                self.onLoadingStateChanged?(false)
                print("PAYMENT ERROR:", error)
                self.onPaymentError?("Не удалось выполнить оплату")
            }
        }
    }
}

private extension PaymentMethodsViewModel{
    func loadCurrencies() {
        onLoadingStateChanged?(true)
            
        currenciesService.loadCurrencies { [weak self] result in
            guard let self else { return }
                
            self.onLoadingStateChanged?(false)
                
            switch result {
            case .success(let currencies):
                self.items = currencies
                self.selectedCurrencyId = nil
                self.onItemsChanged?(currencies)
                self.onPayButtonStateChanged?(false)
                    
            case .failure(let error):
                print("LOAD CURRENCIES ERROR:", error)
                self.onError?("Не удалось загрузить список валют")
            }
        }
    }
}
