//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
