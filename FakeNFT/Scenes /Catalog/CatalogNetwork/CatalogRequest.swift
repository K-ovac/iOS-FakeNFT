//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//
import Foundation

// MARK: - Catalog Request

struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var dto: Dto?
}
