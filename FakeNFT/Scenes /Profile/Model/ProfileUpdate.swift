//
//  ProfileUpdate.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 04.04.2026.
//

struct ProfileUpdate: Encodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let likes: [String]
    let nfts: [String]
}
