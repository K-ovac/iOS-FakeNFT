//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//


// MARK: - Aliases Completion

typealias CatalogCompletion = (Result<[Catalog], Error>) -> Void
typealias NftCollectionCompletion = (Result<Catalog, Error>) -> Void
typealias NftCardCompletion = (Result<NFT, Error>) -> Void
typealias LoadOrderCompletion = (Result<Order, Error>) -> Void
typealias UpdateOrderCompletion = (Result<Order, Error>) -> Void

// MARK: - Protocol CollectionsService

protocol CollectionsService {
    func fetchCategories(completion: @escaping CatalogCompletion)
    func fetchNftCollection(id: String, completion: @escaping NftCollectionCompletion)
    func fetchNftCard(id: String, completion: @escaping NftCardCompletion)
    func loadOrder(completion: @escaping LoadOrderCompletion)
    func updateOrder(nfts: [String], completion: @escaping UpdateOrderCompletion)
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
    
    func fetchNftCard(id: String, completion: @escaping NftCardCompletion) {
        let request = NftRequest(id: id)
        networkClient.send(request: request, type: NFT.self) { result in
            completion(result)
        }
    }
    
    func loadOrder(completion: @escaping LoadOrderCompletion) {
        let request = OrderRequest(id: "1")
        networkClient.send(request: request, type: Order.self) { result in
            completion(result)
        }
    }
    
    func updateOrder(nfts: [String], completion: @escaping UpdateOrderCompletion) {
        let orderUpdate = OrderUpdate(nfts: nfts)
        let request = OrderUpdateRequest(orderUpdate: orderUpdate)
        networkClient.send(request: request, type: Order.self) { result in
            completion(result)
        }
    }
}
