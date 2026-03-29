//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//
 

// MARK: - Aliases Completion

typealias CatalogCompletion = (Result<[Catalog], Error>) -> Void
typealias NftCollectionCompletion = (Result<Catalog, Error>) -> Void

// MARK: - Protocol CollectionsService

protocol CollectionsService {
    func fetchCategories(completion: @escaping CatalogCompletion)
    func fetchNftCollection(id: String, completion: @escaping NftCollectionCompletion)
}

// MARK: - CollectionsServiceImpl

final class CollectionsServiceImpl {
    private let networkClient: NetworkClient
    
    init (networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - Extension CatalogServiceImpl: CatalogService

extension CollectionsServiceImpl: CollectionsService {
    func fetchNftCollection(id: String, completion: @escaping NftCollectionCompletion) {
        let request = NftCollectionRequest(id: id)
        networkClient.send(request: request, type: Catalog.self) { result in
            completion(result)
        }
    }
    
    func fetchCategories(completion: @escaping CatalogCompletion) {
        let request = CatalogRequest()
        networkClient.send(request: request, type: [Catalog].self) { result in
            completion(result)
        }
    }
}
