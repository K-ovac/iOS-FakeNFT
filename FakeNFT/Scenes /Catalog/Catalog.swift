//
//  Catalog.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//

struct Catalog: Decodable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let website: String
    let id: String
}
