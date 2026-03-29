//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        let urlString = "\(RequestConstants.baseURL)/api/v1/profile/1"
        print("📍 Profile URL: \(urlString)")
        return URL(string: urlString)
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var dto: Dto? {
        return nil
    }
}
