//
//  CompleteOrderServiceProtocol.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 14.04.2026.
//

import Foundation

typealias CompleteOrderCompletion = (Result<Void, Error>) -> Void

protocol CompleteOrderServiceProtocol {
    func completeOrder(completion: @escaping CompleteOrderCompletion)
}


