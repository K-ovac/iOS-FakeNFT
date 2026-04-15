//
//  ClearCartService.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 14.04.2026.
//

import Foundation

final class ClearCartService: ClearCartServiceProtocol {
    
    // MARK: - Constants
    
    private enum Constants {
        static let orderId = "1"
        static let successStatusCodeRange = 200..<300
    }
    
    // MARK: - ClearCartServiceProtocol
    
    func clearCart(completion: @escaping ClearCartCompletion) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(Constants.orderId)") else {
            completion(.failure(NetworkClientError.urlSessionError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpBody = "".data(using: .utf8)

        print("CLEAR CART URL:", url.absoluteString)
        print("CLEAR CART BODY: <empty>")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkClientError.urlSessionError))
                    return
                }

                print("CLEAR CART STATUS CODE:", response.statusCode)

                if let data,
                   let responseString = String(data: data, encoding: .utf8) {
                    print("CLEAR CART RESPONSE:", responseString)
                }

                guard Constants.successStatusCodeRange ~= response.statusCode else {
                    completion(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                    return
                }

                completion(.success(()))
            }
        }.resume()
    }
}
