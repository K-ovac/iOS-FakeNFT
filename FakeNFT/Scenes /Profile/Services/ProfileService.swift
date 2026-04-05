//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 03.04.2026.
//

import Foundation

// MARK: - Aliases Completion

typealias ProfileCompletion = (Result<Profile, Error>) -> Void
typealias ProfileUpdateCompletion = (Result<Profile, Error>) -> Void

// MARK: - Protocol Profile Service

protocol ProfileService {
    func loadProfile(completion: @escaping ProfileCompletion)
    func updateProfile(id: String, profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion)
}

// MARK: - ProfileServiceImpl: ProfileService

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateProfile(id: String, profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion) {
        let request = ProfileUpdateRequest(profile: profile)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let updatedProfile):
                completion(.success(updatedProfile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
