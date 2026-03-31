//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 24.03.2026.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias ProfileUpdateCompletion = (Result<Profile, Error>) -> Void

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateProfile(id: String, profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        print("✅ ProfileServiceImpl initialized")
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        print("🔄 Loading profile...")
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                print("✅ Profile loaded successfully: \(profile.name)")
                completion(.success(profile))
            case .failure(let error):
                print("❌ Failed to load profile: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(id: String, profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion) {
        print("🔄 Updating profile...")
        let request = ProfileUpdateRequest(profile: profile)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let updatedProfile):
                print("✅ Profile updated successfully")
                completion(.success(updatedProfile))
            case .failure(let error):
                print("❌ Failed to update profile: \(error)")
                completion(.failure(error))
            }
        }
    }
}
