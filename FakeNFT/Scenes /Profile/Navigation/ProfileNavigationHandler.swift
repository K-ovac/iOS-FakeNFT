//
//  ProfileNavigationHandler.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import UIKit
import SafariServices

protocol ProfileNavigationHandler: AnyObject {
    func navigateToEditProfile(profile: Profile?)
    func navigateToWebsite(url: URL)
    func navigateToMyNFTs(nftIds: [String])
    func navigateToFavorites(nftIds: [String])
}

final class ProfileNavigationHandlerImpl: ProfileNavigationHandler {
    private weak var viewController: UIViewController?
    
    private let onProfileUpdated: (() -> Void)?
    
    init(viewController: UIViewController, onProfileUpdated: (() -> Void)? = nil) {
        self.viewController = viewController
        self.onProfileUpdated = onProfileUpdated
        print("🔗 ProfileNavigationHandlerImpl initialized")
    }
    
    func navigateToEditProfile(profile: Profile?) {
        print("🔜 Navigating to edit profile")
        let editVC = ProfileEditViewController(profile: profile)
        
        editVC.onProfileUpdated = { [weak self] in
            print("✅ Profile updated, refreshing data")
            self?.onProfileUpdated?()
        }
        
        let navController = UINavigationController(rootViewController: editVC)
        viewController?.present(navController, animated: true)
    }
    
    func navigateToWebsite(url: URL) {
        print("🔜 Opening website: \(url)")
        let safariVC = SFSafariViewController(url: url)
        viewController?.present(safariVC, animated: true)
    }
    
    func navigateToMyNFTs(nftIds: [String]) {
        print("🔜 Opening My NFTs screen with IDs: \(nftIds)")
        let myNFTsVC = MyNFTsViewController(nftIds: nftIds)
        viewController?.navigationController?.pushViewController(myNFTsVC, animated: true)
    }
    
    func navigateToFavorites(nftIds: [String]) {
        print("🔜 Opening Favorites screen with IDs: \(nftIds)")
        
        let nftService = NFTListServiceImpl(networkClient: DefaultNetworkClient())
        let profileService = ProfileServiceImpl(networkClient: DefaultNetworkClient())
        
        let viewModel = FavoritesNFTViewModel(
            favoriteIds: nftIds,
            nftService: nftService,
            profileService: profileService
        )
        
        let favoritesVC = FavoritesNFTViewController(viewModel: viewModel)
        viewController?.navigationController?.pushViewController(favoritesVC, animated: true)
    }
}
