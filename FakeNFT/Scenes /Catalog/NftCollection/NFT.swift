//
//  NFT.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 01.04.2026.
//

struct NFT: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let website: String
    let id: String
}
