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
