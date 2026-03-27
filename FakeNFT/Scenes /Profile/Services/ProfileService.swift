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
    func updateProfile(profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion)
}

final class ProfileServiceImpl: ProfileService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        print("✅ ProfileServiceImpl initialized")
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        print("🔄 Loading profile...")
        
        // ВРЕМЕННО: мок данные для тестирования UI
//        let mockProfile = Profile(
//            name: "Иван Петров",
//            avatar: "https://i.pravatar.cc/300",
//            description: "iOS разработчик. Люблю создавать красивые приложения.",
//            website: "https://example.com",
//            nfts: ["1", "2", "3"],
//            likes: ["1"],
//            id: "1"
//        )
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            print("✅ Using mock profile data")
//            completion(.success(mockProfile))
//        }
        
        // Реальный запрос
        
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
    
    func updateProfile(profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion) {
        print("🔄 Updating profile...")
        
        // ВРЕМЕННО: Имитируем успешное обновление
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            print("✅ Profile updated successfully (mock)")
//            let updatedProfile = Profile(
//                name: profile.name,
//                avatar: profile.avatar,
//                description: profile.description,
//                website: profile.website,
//                nfts: profile.nfts,
//                likes: profile.likes,
//                id: "1"
//            )
//            completion(.success(updatedProfile))
//        }
        
        // Реальный запрос
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
