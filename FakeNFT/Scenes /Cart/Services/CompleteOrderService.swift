//
//  CompleteOrderService.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 14.04.2026.
//

import Foundation

final class CompleteOrderService: CompleteOrderServiceProtocol {
    
    private let networkClient: NetworkClient
    private let orderId = "1"
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func completeOrder(completion: @escaping CompleteOrderCompletion) {
        print("COMPLETE ORDer START")
        
        let request = OrderRequest(id: orderId)
        
        networkClient.send(request: request, type: Order.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let order):
                print("COMPLETE ORDER fetched ids: ", order.nfts)
                self.sendCompleteRequest(nftIds: order.nfts, completion: completion)
                
            case .failure(let error):
                print("COMPLETE ERROR load order error: ", error)
                completion(.failure(error))
            }
        }
    }
    
    private func sendCompleteRequest(nftIds: [String], completion: @escaping CompleteOrderCompletion) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)") else {
            completion(.failure(NetworkClientError.urlSessionError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let bodyString = nftIds
            .compactMap { id in
                id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    .map { "nfts=\($0)" }
            }
            .joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        print("COMPLETE ORDER URL: ", url.absoluteString)
        print("COMPLETE ORDER BODY: ", bodyString)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    print("ERROR ORDER REQUEST ERROR: ", error)
                    completion(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("COMPLETE ORDER no http url response")
                    completion(.failure(NetworkClientError.urlSessionError))
                    return
                }
                
                print("COMPLETE ORDER STATUS CODE:", response.statusCode)
                
                if let data,
                   let responseString = String(data: data, encoding: .utf8) {
                    print("COMPLETE ORDER RESPONSE: ", responseString)
                }
                
                guard 200..<300 ~= response.statusCode else {
                    completion(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                    return
                }
                
                completion(.success(()))
            }
        }.resume()
    }
}
