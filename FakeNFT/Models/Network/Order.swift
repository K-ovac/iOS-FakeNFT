//
//  Order.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 01.04.2026.
//

struct Order: Decodable {
    let id: String
    let nfts: [String]
}
