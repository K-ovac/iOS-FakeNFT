//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let profile: ProfileUpdate
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        return .put
    }
    
    var dto: Dto? {
        return ProfileUpdateDto(profile: profile)
    }
    
    var headers: [String: String]? {
        return nil
    }
}

struct ProfileUpdateDto: Dto {
    let profile: ProfileUpdate
    
    func asDictionary() -> [String: String] {
        var dict: [String: String] = [:]
        
        dict["name"] = profile.name
        dict["avatar"] = profile.avatar
        dict["website"] = profile.website
        dict["likes"] = profile.likes.joined(separator: ",")
        dict["nfts"] = profile.nfts.joined(separator: ",")
        
        if let description = profile.description, !description.isEmpty {
            dict["description"] = description
        }
        
        print("📤 Update payload: \(dict)")
        
        return dict
    }
}
