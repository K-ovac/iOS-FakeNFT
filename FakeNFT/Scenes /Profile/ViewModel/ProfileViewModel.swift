//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import Foundation

protocol ProfileViewModelProtocol: AnyObject {
    var onDataChange: (() -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    var profile: Profile? { get }
    var nftsCount: Int { get }
    var likesCount: Int { get }
    
    func fetchProfile()
    func editProfile()
    func openWebsite()
    func showMyNFTs()
    func showFavorites()
    func setNavigationHandler(_ handler: ProfileNavigationHandler)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    var onDataChange: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    private(set) var profile: Profile? {
        didSet {
            onDataChange?()
        }
    }
    
    var nftsCount: Int {
        return profile?.nfts.count ?? 0
    }
    
    var likesCount: Int {
        return profile?.likes.count ?? 0
    }
    
    private let profileService: ProfileService
    private var navigationHandler: ProfileNavigationHandler?
    
    init(profileService: ProfileService, navigationHandler: ProfileNavigationHandler? = nil) {
        self.profileService = profileService
        self.navigationHandler = navigationHandler
        print("📦 ProfileViewModel initialized")
    }
    
    func setNavigationHandler(_ handler: ProfileNavigationHandler) {
        self.navigationHandler = handler
        print("🔗 Navigation handler set")
    }
    
    func fetchProfile() {
        print("🔄 Fetching profile...")
        onLoadingStateChange?(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.profileService.loadProfile { result in
                DispatchQueue.main.async {
                    self?.onLoadingStateChange?(false)
                    
                    switch result {
                    case .success(let profile):
                        print("✅ Profile received: \(profile.name)")
                        self?.profile = profile
                    case .failure(let error):
                        print("❌ Profile loading error: \(error)")
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func editProfile() {
        navigationHandler?.navigateToEditProfile(profile: profile)
    }
    
    func openWebsite() {
        guard let websiteString = profile?.website,
              let url = URL(string: websiteString) else { return }
        navigationHandler?.navigateToWebsite(url: url)
    }
    
    func showMyNFTs() {
        guard let nftIds = profile?.nfts else { return }
        navigationHandler?.navigateToMyNFTs(nftIds: nftIds)
    }
    
    func showFavorites() {
        guard let favoriteIds = profile?.likes else { return }
        navigationHandler?.navigateToFavorites(nftIds: favoriteIds)
    }
}
