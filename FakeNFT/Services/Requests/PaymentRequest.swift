//
//  PaymentRequest.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 13.04.2026.
//

import Foundation

struct PaymentRequest: NetworkRequest {
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}
