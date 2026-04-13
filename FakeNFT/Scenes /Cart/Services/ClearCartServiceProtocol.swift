//
//  ClearCartServiceProtocol.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 14.04.2026.
//

import Foundation

typealias ClearCartCompletion = (Result<Void, Error>) -> Void

protocol ClearCartServiceProtocol {
    func clearCart(completion: @escaping ClearCartCompletion)
}
