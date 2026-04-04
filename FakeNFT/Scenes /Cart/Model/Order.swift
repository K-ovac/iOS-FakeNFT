//
//  Order.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 04.04.2026.
//

struct Order: Decodable {
    let nfts: [String]
    let id: String
}
