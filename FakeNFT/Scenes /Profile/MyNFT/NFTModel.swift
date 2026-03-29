//
//  NFTModel.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 26.03.2026.
//

import Foundation

struct NFT: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double
    let author: String
    let createdAt: String?
}

struct NFTAuthor: Decodable {
    let name: String
    let avatar: String
    let id: String
}

// Модель для отображения в списке
struct NFTDisplayModel {
    let id: String
    let name: String
    let imageUrl: URL?
    let rating: Int
    let price: Double
    let author: String
}
