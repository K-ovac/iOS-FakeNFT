//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//
 

// MARK: - Alias CatalogCompletion

typealias CatalogCompletion = (Result<[Catalog], Error>) -> Void

// MARK: - Protocol CatalogService

protocol CatalogService {
    func fetchCategories(completion: @escaping CatalogCompletion)
}

// MARK: - CatalogServiceImpl

final class CatalogServiceImpl {
    private let networkClient: NetworkClient
    
    init (networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

// MARK: - Extension CatalogServiceImpl: CatalogService

extension CatalogServiceImpl: CatalogService {
    func fetchCategories(completion: @escaping CatalogCompletion) {
        let request = CatalogRequest()
        networkClient.send(request: request, type: [Catalog].self) { result in
            completion(result)
        }
    }
}
