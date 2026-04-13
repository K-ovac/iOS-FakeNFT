//
//  ProfileUpdateRequest.swift
//  FakeNFT
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let profile: ProfileUpdate
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Dto? {
        ProfileUpdateDto(profile: profile)
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/x-www-form-urlencoded"]
    }
}

struct ProfileUpdateDto: Dto {
    let profile: ProfileUpdate
    
    func asDictionary() -> [String: String] {
        var dict: [String: String] = [
            "name": profile.name,
            "avatar": profile.avatar,
            "website": profile.website,
            "description": profile.description
        ]
        
        if !profile.likes.isEmpty {
            dict["likes"] = profile.likes.joined(separator: ",")
        }
        
        if !profile.nfts.isEmpty {
            dict["nfts"] = profile.nfts.joined(separator: ",")
        }
        
        print("📤 Update payload: \(dict)")
        return dict
    }
}
