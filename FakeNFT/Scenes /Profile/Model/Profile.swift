//
//  Profile.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

// Модель для обновления
struct ProfileUpdate: Encodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let likes: [String]
    let nfts: [String]
}
