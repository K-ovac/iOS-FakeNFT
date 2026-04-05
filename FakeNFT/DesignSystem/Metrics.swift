//
//  Metrics.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//
import Foundation

// MARK: - Metrics

enum Metrics {
    
    // MARK: - Spacing
    
    enum Spacing {
        static let spacing0: CGFloat = 0
        static let spacing2: CGFloat = 2
        static let spacing4: CGFloat = 4
        static let spacing5: CGFloat = 5
        static let spacing8: CGFloat = 8
        static let spacing9: CGFloat = 9
        static let spacing13: CGFloat = 13
        static let spacing16: CGFloat = 16
        static let spacing17: CGFloat = 17
        static let spacing24: CGFloat = 24
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    // MARK: - Sizes
    
    enum Sizes {
        //Catalog
        static let size0: CGFloat = 0
        static let cellCatalogHeight: CGFloat = 187
        static let nftCollectionImageHeight: CGFloat = 310
        static let nftCardHeight: CGFloat = 192
        static let nftCardImageHeight: CGFloat = 108
        static let nftCardButtonSize: CGFloat = 40
        static let nftCardRatingSize: CGFloat = 12
    }
}
