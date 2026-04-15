//
//  CompleteOrderRequest.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 14.04.2026.
//

import Foundation

struct CompleteOrderRequest: NetworkRequest {
    let dto: Dto?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .post
    }
}
