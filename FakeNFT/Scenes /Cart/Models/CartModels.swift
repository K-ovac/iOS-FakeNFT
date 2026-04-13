//
//  CartModels.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 29.03.2026.
//

import Foundation
import UIKit

struct CartItem {
    let id: String
    let name: String
    let price: Double
    let rating: Int
    let imageURL: URL?
}

struct CartSummary {
    let itemsCount: Int
    let totalPrice: Double
}

enum CartSortOption: String, CaseIterable {
    case byName
    case byPrice
    case byRating
    
    var title: String {
        switch self {
        case .byName:
            return NSLocalizedString("cartModels.sort.byName", comment: "")
        case .byPrice:
            return NSLocalizedString("cartModels.sort.byPrice", comment: "")
        case .byRating:
            return NSLocalizedString("cartModels.sort.byRating", comment: "")
        }
    }
}

enum CartViewState {
    case loading
    case content
    case empty
    case error(String)
}
