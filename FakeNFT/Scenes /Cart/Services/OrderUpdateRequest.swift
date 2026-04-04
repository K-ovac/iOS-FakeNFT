//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 04.04.2026.
//
import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let orderUpdate: OrderUpdate
    
    var httpMethod: HttpMethod { .put }
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var dto: Dto? {
        OrderUpdateDto(orderUpdate: orderUpdate)
    }
}
