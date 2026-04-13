//
//  NFT.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 01.04.2026.
//

import Foundation

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

struct NFTAuthor: Decodable {
    let name: String
    let avatar: String
    let id: String
}

struct NFTDisplayModel {
    let id: String
    let name: String
    let imageUrl: String?
    let rating: Int
    let price: Float
    let author: String
}
