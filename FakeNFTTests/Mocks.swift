//
//  Mocks.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 05.04.2026.
//


@testable import FakeNFT
import Foundation
import XCTest

// MARK: - Mock Profile Service

final class MockProfileService: ProfileService {
    var loadProfileResult: Result<Profile, Error>?
    var updateProfileResult: Result<Profile, Error>?
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        if let result = loadProfileResult {
            completion(result)
        }
    }
    
    func updateProfile(id: String, profile: ProfileUpdate, completion: @escaping ProfileUpdateCompletion) {
        if let result = updateProfileResult {
            completion(result)
        }
    }
}

// MARK: - Mock NFT List Service

final class MockNFTListService: NFTListService {
    var loadNFTsResult: Result<[NFT], Error>?
    var loadAuthorResult: Result<NFTAuthor, Error>?
    
    func loadNFTs(ids: [String], completion: @escaping NFTListCompletion) {
        if let result = loadNFTsResult {
            completion(result)
        } else {
            completion(.success([]))
        }
    }
    
    func loadAuthor(id: String, completion: @escaping NFTAuthorCompletion) {
        if let result = loadAuthorResult {
            completion(result)
        } else {
            let defaultAuthor = NFTAuthor(name: "Unknown", avatar: "", id: id)
            completion(.success(defaultAuthor))
        }
    }
}

// MARK: - Mock Navigation Handler

final class MockProfileNavigationHandler: ProfileNavigationHandler {
    var navigateToEditProfileCalled = false
    var navigateToWebsiteCalled = false
    var navigateToMyNFTsCalled = false
    var navigateToFavoritesCalled = false
    
    var passedProfile: Profile?
    var passedUrl: URL?
    var passedNftIds: [String]?
    var passedFavoriteIds: [String]?
    
    func navigateToEditProfile(profile: Profile?) {
        navigateToEditProfileCalled = true
        passedProfile = profile
    }
    
    func navigateToWebsite(url: URL) {
        navigateToWebsiteCalled = true
        passedUrl = url
    }
    
    func navigateToMyNFTs(nftIds: [String]) {
        navigateToMyNFTsCalled = true
        passedNftIds = nftIds
    }
    
    func navigateToFavorites(nftIds: [String]) {
        navigateToFavoritesCalled = true
        passedFavoriteIds = nftIds
    }
}
