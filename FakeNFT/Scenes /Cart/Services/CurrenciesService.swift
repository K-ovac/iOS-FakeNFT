//
//  CurrenciesService.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import Foundation

final class CurrenciesService: CurrenciesServiceProtocol {
    
    // MARK: - Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - CurrenciesServiceProtocol
    
    func loadCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = CurrenciesRequest()
        
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
