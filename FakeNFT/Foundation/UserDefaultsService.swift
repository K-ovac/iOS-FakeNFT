//
//  UserDefaultsService.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 26.03.2026.
//

import Foundation

final class UserDefaultsService {
    
    // MARK: - Singleton
    
    static let shared = UserDefaultsService()
    
    // MARK: - Properties
    
    private let storage: UserDefaults = .standard
    
    // MARK: - Init
    
    private init() {}   //без создания извне
}

// MARK: - Keys

extension UserDefaultsService {
    private enum Keys: String {
        case sortCategory
        
        var value: String { rawValue }
    }
}

// MARK: - Catalog Sorting

extension UserDefaultsService {
    func getCategorySort() -> CatalogSortType {
        if let saved = storage.string(forKey: Keys.sortCategory.value),
            let sortType = CatalogSortType(rawValue: saved) {
            return sortType
        }
        return .byNftsCount
    }
    
    func setCategorySort(for sort: CatalogSortType) {
        storage.set(sort.rawValue, forKey: Keys.sortCategory.value)
    }
}
