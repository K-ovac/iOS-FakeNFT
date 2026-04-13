//
//  FavoritesNFTViewModel.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 29.03.2026.
//

import Foundation

protocol FavoritesNFTViewModelProtocol: AnyObject {
    var nfts: [FavoritesNFTDisplayModel] { get }
    var onDataChange: (() -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func fetchFavorites()
    func removeFromFavorites(nftId: String)
}

final class FavoritesNFTViewModel: FavoritesNFTViewModelProtocol {
    
    var nfts: [FavoritesNFTDisplayModel] = [] {
        didSet {
            onDataChange?()
        }
    }
    
    var onDataChange: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    private var favoriteIds: [String]
    private let nftService: NFTListService
    private let profileService: ProfileService
    private var currentProfileId: String?
    
    init(favoriteIds: [String], nftService: NFTListService, profileService: ProfileService) {
        self.favoriteIds = favoriteIds
        self.nftService = nftService
        self.profileService = profileService
        print("⭐️ FavoritesNFTViewModel initialized with \(favoriteIds.count) favorites")
        
        loadProfileId()
    }
    
    private func loadProfileId() {
        profileService.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.currentProfileId = profile.id
                print("⭐️ Loaded profile ID: \(profile.id)")
            case .failure(let error):
                print("⭐️ Failed to load profile ID: \(error)")
            }
        }
    }
    
    func fetchFavorites() {
        guard !favoriteIds.isEmpty else {
            nfts = []
            return
        }
        
        onLoadingStateChange?(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.nftService.loadNFTs(ids: self?.favoriteIds ?? []) { result in
                DispatchQueue.main.async {
                    self?.onLoadingStateChange?(false)
                    
                    switch result {
                    case .success(let nfts):
                        print("⭐️ Loaded \(nfts.count) favorite NFTs")
                        self?.processNFTs(nfts)
                    case .failure(let error):
                        print("⭐️ Error loading favorites: \(error)")
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func processNFTs(_ nfts: [NFT]) {
        let displayModels = nfts.map { nft in
            FavoritesNFTDisplayModel(
                id: nft.id,
                name: nft.name,
                imageUrl: nft.images.first,
                rating: nft.rating,
                price: nft.price
            )
        }
        self.nfts = displayModels
    }
    
    func removeFromFavorites(nftId: String) {
        nfts.removeAll { $0.id == nftId }
        
        favoriteIds = nfts.map { $0.id }
        
        profileService.loadProfile { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                let updatedProfile = ProfileUpdate(
                    name: profile.name,
                    avatar: profile.avatar,
                    description: profile.description ?? "",
                    website: profile.website,
                    likes: self.favoriteIds,
                    nfts: profile.nfts
                )
                
                self.profileService.updateProfile(id: profile.id, profile: updatedProfile) { updateResult in
                    DispatchQueue.main.async {
                        switch updateResult {
                        case .success:
                            print("⭐️ Successfully removed from favorites")
                        case .failure(let error):
                            print("⭐️ Failed to update favorites: \(error)")
                            self.fetchFavorites()
                            self.onError?("Не удалось удалить из избранного")
                        }
                    }
                }
                
            case .failure(let error):
                print("⭐️ Failed to load profile for update: \(error)")
                self.fetchFavorites()
                self.onError?("Не удалось обновить список избранного")
            }
        }
    }
}
