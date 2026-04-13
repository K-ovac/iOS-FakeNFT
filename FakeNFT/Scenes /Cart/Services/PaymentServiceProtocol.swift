//
//  PaymentServiceProtocol.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import Foundation

typealias PaymentCompletion = (Result<PaymentResponse, Error>) -> Void

protocol PaymentServiceProtocol {
    func pay(currencyId: String, completion: @escaping PaymentCompletion)
}
