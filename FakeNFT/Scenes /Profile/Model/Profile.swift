//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 03.04.2026.
//

struct Profile: Decodable {
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
