//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 29.03.2026.
//

import Foundation

protocol CartViewModelProtocol {
    var onItemsChanged: (([CartItem]) -> Void)? { get set }
    var onSummaryChanged: ((CartSummary) -> Void)? { get set }
    var onStateChanged: ((CartViewState) -> Void)? { get set }
    var onShowDeleteConfirmation: ((CartItem) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

    func viewDidLoad()
    func didSelectSort(_ option: CartSortOption)
    func didTapDelete(for item: CartItem)
    func confirmDelete()
}

final class CartViewModel: CartViewModelProtocol {
    var onItemsChanged: (([CartItem]) -> Void)?
    var onSummaryChanged: ((CartSummary) -> Void)?
    var onStateChanged: ((CartViewState) -> Void)?
    var onShowDeleteConfirmation: ((CartItem) -> Void)?
    var onError: ((String) -> Void)?

    private var items: [CartItem] = []
    private var sortOption: CartSortOption = .byName
    private let sortOptionKey = "cartSortOption"
    
    private let cartService: CartServiceProtocol
    
    private var pendingDeleteItem: CartItem?

    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    func viewDidLoad() {
        sortOption = loadSavedSortOption()
        loadCart()
    }

    private func loadCart() {
        onStateChanged?(.loading)

        cartService.loadCart { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let items):
                self.items = items
                self.applySort()
                
                if self.items.isEmpty {
                    self.onStateChanged?(.empty)
                } else {
                    self.onStateChanged?(.content)
                    self.onItemsChanged?(items)
                    self.onSummaryChanged?(makeSummary())
                }
            case .failure(let error):
                self.onStateChanged?(.error(error.localizedDescription))
            }
        }
        
    }

    private func makeSummary() -> CartSummary {
        let totalPrice = items.reduce(0) { $0 + $1.price }
        return CartSummary(itemsCount: items.count, totalPrice: totalPrice)
    }
    
    func didSelectSort(_ option: CartSortOption) {
        sortOption = option
        saveSortOption(option)
        applySort()
        onItemsChanged?(items)
    }
    
    private func applySort() {
        switch sortOption {
        case .byName:
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .byPrice:
            items.sort { $0.price < $1.price }
        case .byRating:
            items.sort { $0.rating > $1.rating }
        }
    }
    
    private func saveSortOption(_ option: CartSortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
    
    private func loadSavedSortOption() -> CartSortOption {
        guard
            let rawValue = UserDefaults.standard.string(forKey: sortOptionKey),
            let option = CartSortOption(rawValue: rawValue)
        else {
            return .byName
        }
        return option
    }
    
    func didTapDelete(for item: CartItem) {
        pendingDeleteItem = item
        onShowDeleteConfirmation?(item)
    }
    
    func confirmDelete() {
        guard let item = pendingDeleteItem else { return }
        
        cartService.removeFromCart(id: item.id) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success:
                self.pendingDeleteItem = nil
                self.loadCart()
            case .failure(let error):
                print("DELETE ERROR:", error)
                self.pendingDeleteItem = nil
                self.onError?("Не удалось удалить NFT из корзины")
            }
        }
    }
}
