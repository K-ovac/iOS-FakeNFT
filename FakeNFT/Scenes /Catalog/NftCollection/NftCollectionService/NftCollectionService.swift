//
//  NftCollectionService.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 28.03.2026.
//

// MARK: - Alias NftCollectionCompletion

typealias NftCollectionCompletion = (Result<Catalog, Error>) -> Void

// MARK: - Protocol NftCollectionService

protocol NftCollectionService {
    func fetchNftCollection(id: String, completion: @escaping NftCollectionCompletion)
}

// MARK: - NftCollectionServiceImpl

final class NftCollectionServiceImpl {
    private let networkClient: NetworkClient
    
    init (networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - Extension NftCollectionServiceImpl: NftCollectionService

extension NftCollectionServiceImpl: NftCollectionService {
    func fetchNftCollection(id: String, completion: @escaping NftCollectionCompletion) {
        let request = NftCollectionRequest(id: id)
        networkClient.send(request: request, type: Catalog.self) { result in
            completion(result)
        }
    }
}
