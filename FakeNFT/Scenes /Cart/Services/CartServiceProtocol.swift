//
//  CartServiceProtocol.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 01.04.2026.
//

typealias CartItemsCompletion = (Result<[CartItem], Error>) -> Void
typealias CartActionCompletion = (Result<Void, Error>) -> Void

protocol CartServiceProtocol {
    func loadCart(completion: @escaping CartItemsCompletion)
    func removeFromCart(id: String, completion: @escaping (Result<Void, Error>) -> Void)
}
