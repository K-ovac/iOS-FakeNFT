//
//  PaymentResponse.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import Foundation

struct PaymentResponse: Decodable {
    let success: Bool
    let orderId: String
    let id: String
}
