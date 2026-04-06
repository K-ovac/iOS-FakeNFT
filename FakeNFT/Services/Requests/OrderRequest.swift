//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 01.04.2026.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let id: String

    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/orders/\(id)"
        print("ORDER URL:", urlString)
        return URL(string: urlString)
    }

    var dto: Dto?
}
