//
//  CartServiceProtocol.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 01.04.2026.
//

typealias CartItemsCompletion = (Result<[CartItem], Error>) -> Void

protocol CartServiceProtocol {
    func loadCart(completion: @escaping CartItemsCompletion)
}
