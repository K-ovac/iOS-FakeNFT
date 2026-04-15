//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import Foundation

final class PaymentService: PaymentServiceProtocol {
    
    // MARK: - Properties
    
    private let networkClient: NetworkClient
    
    // MARK: - Init
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    // MARK: - PaymentServiceProtocol
    
    func pay(currencyId: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(currencyId: currencyId)
        
        networkClient.send(request: request, type: PaymentResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
