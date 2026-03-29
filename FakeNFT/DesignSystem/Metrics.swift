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
        static let verySmall: CGFloat = 4
        static let spacing5: CGFloat = 5
        static let small: CGFloat = 8
        static let smallLarge: CGFloat = 13
        static let medium: CGFloat = 16
        static let mediumLarge: CGFloat = 17
        static let large: CGFloat = 24
    }
    
    // MARK: - Corner Radius
    
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    // MARK: - Sizes
    
    enum Sizes {
        static let cellCatalogHeight: CGFloat = 187
        static let nftCollectionImageHeight: CGFloat = 310
    }
}
