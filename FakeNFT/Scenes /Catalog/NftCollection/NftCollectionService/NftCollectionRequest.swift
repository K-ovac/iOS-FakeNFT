//
//  NftCollectionRequest.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 28.03.2026.
//
import Foundation

// MARK: - Nft Collection Request

struct NftCollectionRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(id)")
    }
    var dto: Dto?
}

