//
//  CartService.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 29.03.2026.
//

import Foundation

final class CartService: CartServiceProtocol {
    private let networkClient: NetworkClient
    private let nftService: NftService
    private let orderId = "1"

    init(networkClient: NetworkClient, nftService: NftService) {
        self.networkClient = networkClient
        self.nftService = nftService
    }

    func loadCart(completion: @escaping CartItemsCompletion) {
        let request = OrderRequest(id: orderId)

        networkClient.send(request: request, type: Order.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let order):
                print("order id:", order.id)
                print("nft ids:", order.nfts)
                self.loadNfts(ids: order.nfts, completion: completion)

            case .failure(let error):
                print("order loading error:", error)
                completion(.failure(error))
            }
        }
    }
    
    func removeFromCart(id: String, completion: @escaping CartActionCompletion) {
        let request = OrderRequest(id: orderId)

        networkClient.send(request: request, type: Order.self) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let order):
                let updatedIds = order.nfts.filter { $0 != id }

                print("remove id:", id)
                print("before:", order.nfts)
                print("after:", updatedIds)

                self.updateOrder(orderId: self.orderId, nftIds: updatedIds, completion: completion)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateOrder(orderId: String, nftIds: [String], completion: @escaping CartActionCompletion) {
        guard let url = URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)") else {
            completion(.failure(NetworkClientError.urlSessionError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyString = nftIds
            .compactMap { id in
                id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    .map { "nfts=\($0)" }
            }
            .joined(separator: "&")

        request.httpBody = bodyString.data(using: .utf8)

        print("UPDATE BODY:", bodyString)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error {
                    completion(.failure(error))
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(NetworkClientError.urlSessionError))
                    return
                }

                print("UPDATE STATUS CODE:", response.statusCode)

                guard 200..<300 ~= response.statusCode else {
                    completion(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                    return
                }

                completion(.success(()))
            }
        }.resume()
    }
    
    private func loadNfts(ids: [String], completion: @escaping CartItemsCompletion) {
        if ids.isEmpty {
            completion(.success([]))
            return
        }

        let group = DispatchGroup()
        let lockQueue = DispatchQueue(label: "cart.service.lock")
        var cartItems: [CartItem] = []
        var firstError: Error?

        for id in ids {
            group.enter()

            nftService.loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    let item = CartItem(
                        id: nft.id,
                        name: nft.name,
                        price: nft.price,
                        rating: nft.rating,
                        imageURL: URL(string: nft.images.first ?? "")
                    )

                    lockQueue.async {
                        cartItems.append(item)
                    }
                    group.leave()

                case .failure(let error):
                    lockQueue.async {
                        if firstError == nil {
                            firstError = error
                        }
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            if let error = firstError {
                completion(.failure(error))
            } else {
                completion(.success(cartItems))
            }
        }
    }
}
