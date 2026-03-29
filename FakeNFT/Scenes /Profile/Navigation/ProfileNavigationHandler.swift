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
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        print("🔗 ProfileNavigationHandlerImpl initialized")
    }
    
    func navigateToEditProfile(profile: Profile?) {
        print("🔜 Navigating to edit profile")
        let editVC = ProfileEditViewController(profile: profile)
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
        print("🔜 Favorites screen will be implemented - received IDs: \(nftIds)")
        
        let alert = UIAlertController(
            title: "Избранные NFT",
            message: "Экран будет реализован позже\nПолучено NFT: \(nftIds.count)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }
}
