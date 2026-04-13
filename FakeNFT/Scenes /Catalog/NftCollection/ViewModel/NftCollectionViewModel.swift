//
//  NftCollectionViewModel.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 28.03.2026.
//

import Foundation

// MARK: - State

enum NftCollectionState {
    case initial
    case loading
    case data(Catalog)
    case failed(Error)
}

// MARK: - NftCollectionViewModel

final class NftCollectionViewModel {
    
    // MARK: - Closures
    
    var onNftCollectionFetched: (() -> Void)?
    var onError: ((ErrorModel) -> Void)?
    var onLoadingStarted: (() -> Void)?
    var onLoadingStopped: (() -> Void)?
    var onNftsFetched: (() -> Void)?
    var onFavoritesUpdated: (() -> Void)?
    var onCartUpdated: (() -> Void)?
    
    // MARK: - Properties
    
    private var nftCollectionService: CollectionsService
    private var profileService: ProfileService
    
    private var state: NftCollectionState = .initial {
        didSet {
            stateDidChanged()
        }
    }
    private(set) var nftCollection: Catalog? {
        didSet {
            onNftCollectionFetched?()
        }
    }
    
    private(set) var nfts: [NFT] = [] {
        didSet {
            onNftsFetched?()
        }
    }
    
    private let nftCollectionId: String
    private var likedNftIds: [String] = []
    private var cartNftIds: [String] = []
    
    //MARK: - Init
    
    init(nftCollectionService: CollectionsService, nftCollectionId: String, profileService: ProfileService) {
        self.nftCollectionService = nftCollectionService
        self.nftCollectionId = nftCollectionId
        self.profileService = profileService
    }
    
    // MARK: - Fetch NFT Collection
    
    func fetchNftCollectionInfo() {
        state = .loading
        
        let group = DispatchGroup()
        var loadedCollection: Catalog?
        var loadedLikes: [String] = []
        var loadedCart: [String] = []
        
        group.enter()
        nftCollectionService.fetchNftCollection(id: nftCollectionId) { result in
            if case .success(let collection) = result {
                loadedCollection = collection
            }
            group.leave()
        }
        
        group.enter()
        profileService.loadProfile { result in
            if case .success(let profile) = result {
                loadedLikes = profile.likes
            }
            group.leave()
        }
        
        group.enter()
        nftCollectionService.loadOrder { result in
            if case .success(let order) = result {
                loadedCart = order.nfts
            }
            group.leave()
        }

        group.notify(queue: .main) { [weak self] in
            self?.likedNftIds = loadedLikes
            self?.cartNftIds = loadedCart
            if let collection = loadedCollection {
                self?.state = .data(collection)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            break
        case .loading:
            onLoadingStarted?()
        case .data(let collection):
            nftCollection = collection
            fetchNfts(nftsId: collection.nfts)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            onLoadingStopped?()
            onError?(errorModel)
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = LocalizableKeys.errorNetwork
        default:
            message = LocalizableKeys.errorUnknown
        }
        
        let actionText = LocalizableKeys.errorRepeat
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.fetchNftCollectionInfo()
        }
    }
}

//MARK: - Extension NftCollectionViewModel for Nft Card

extension NftCollectionViewModel {
    
    // MARK: - Factory Methods
    
    func numberOfNfts() -> Int {
        nfts.count
    }
    
    func nft(at index: Int) -> NFT {
        nfts[index]
    }
    
    // MARK: - Fetch nfts
    
    private func fetchNfts(nftsId: [String]) {
        let dispatchGroup = DispatchGroup()
        let lockQueue = DispatchQueue(label: "nftLockQueue")
        var fetchedNfts: [NFT] = []
        
        nftsId.forEach { nftId in
            dispatchGroup.enter()
            
            nftCollectionService.fetchNftCard(id: nftId) { result in
                switch result {
                case .success(let nft):
                    lockQueue.async {
                        fetchedNfts.append(nft)
                        dispatchGroup.leave()
                    }
                case .failure(let error):
                    print(error)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.nfts = fetchedNfts
            self?.onLoadingStopped?()
        }
    }
    
    // MARK: Favorite Button Methods
    
    func toggleFavorite(nftId: String) {
        if likedNftIds.contains(nftId) {
            likedNftIds.removeAll { $0 == nftId }
        } else {
            likedNftIds.append(nftId)
        }
        onFavoritesUpdated?()
        
        profileService.loadProfile { [weak self] result in
            guard let self else { return }
            if case .success(let profile) = result {
                let updatedProfile = ProfileUpdate(
                    name: profile.name,
                    avatar: profile.avatar,
                    description: profile.description ?? "",
                    website: profile.website,
                    likes: self.likedNftIds,
                    nfts: profile.nfts
                )
                self.profileService.updateProfile(id: profile.id, profile: updatedProfile) { _ in }
            }
        }
        onNftCollectionFetched?()
    }
    
    func isLiked(nftId: String) -> Bool {
        likedNftIds.contains(nftId)
    }
    
    // MARK: - Cart Button Methods
    
    func toggleCart(nftId: String) {
        if cartNftIds.contains(nftId) {
            cartNftIds.removeAll { $0 == nftId }
        } else {
            cartNftIds.append(nftId)
        }
        onCartUpdated?()
        
        nftCollectionService.updateOrder(nfts: cartNftIds) { [weak self] result in
            if case .failure = result {
                if self?.cartNftIds.contains(nftId) == true {
                    self?.cartNftIds.removeAll { $0 == nftId }
                } else {
                    self?.cartNftIds.append(nftId)
                }
                DispatchQueue.main.async {
                    self?.onCartUpdated?()
                }
            }
        }
    }
    
    func isInCart(nftId: String) -> Bool {
        cartNftIds.contains(nftId)
    }
}
