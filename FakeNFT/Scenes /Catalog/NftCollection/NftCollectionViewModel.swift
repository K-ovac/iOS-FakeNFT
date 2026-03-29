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
    
    // MARK: - Properties
    
    private var nftCollectionService: CollectionsService
    
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
    private let nftCollectionId: String
    
    //MARK: - Init
    
    init(nftCollectionService: CollectionsService, nftCollectionId: String) {
        self.nftCollectionService = nftCollectionService
        self.nftCollectionId = nftCollectionId

    }
    
    // MARK: - Fetch NFT Collection
    
    func fetchNftCollectionInfo() {
        state = .loading
        nftCollectionService.fetchNftCollection(id: nftCollectionId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nftCollection):
                    self?.state = .data(nftCollection)
                    print("Загружена Nft коллекция: ", nftCollection.name)
                case .failure(let error):
                    print(error)
                    self?.state = .failed(error)
                }
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
            onLoadingStopped?()
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
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.fetchNftCollectionInfo()
        }
    }
}
