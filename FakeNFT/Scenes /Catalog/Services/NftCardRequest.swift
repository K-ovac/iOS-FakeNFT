//
//  NftCardRequest.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 02.04.2026.
//
import Foundation

struct NftRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
    var dto: Dto?
}
