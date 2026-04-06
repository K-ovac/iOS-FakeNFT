//
//  ProfileEditViewModelTests.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 05.04.2026.
//

@testable import FakeNFT
import XCTest

final class ProfileEditViewModelTests: XCTestCase {
    
    var sut: ProfileEditViewModel!
    var mockProfileService: MockProfileService!
    
    override func setUp() {
        super.setUp()
        mockProfileService = MockProfileService()
        sut = ProfileEditViewModel(profileService: mockProfileService)
    }
    
    override func tearDown() {
        sut = nil
        mockProfileService = nil
        super.tearDown()
    }
    
    func testSaveProfile_Success_CallsOnSaveSuccess() {
        // Given
        let profile = Profile(
            name: "Test User",
            avatar: "https://example.com/avatar.jpg",
            description: "Test",
            website: "https://example.com",
            nfts: [],
            likes: [],
            id: "1"
        )
        let profileUpdate = ProfileUpdate(
            name: "Updated Name",
            avatar: "https://example.com/new-avatar.jpg",
            description: "New description",
            website: "https://example.com",
            likes: [],
            nfts: []
        )
        mockProfileService.updateProfileResult = .success(profile)
        
        let expectation = XCTestExpectation(description: "Save success called")
        sut.onSaveSuccess = {
            expectation.fulfill()
        }
        
        // When
        sut.saveProfile(profileUpdate, profileId: "1")
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSaveProfile_Failure_CallsOnError() {
        // Given
        let profileUpdate = ProfileUpdate(
            name: "Updated Name",
            avatar: "https://example.com/new-avatar.jpg",
            description: "New description",
            website: "https://example.com",
            likes: [],
            nfts: []
        )
        let expectedError = NSError(domain: "UpdateError", code: 500)
        mockProfileService.updateProfileResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Error called")
        sut.onError = { _ in
            expectation.fulfill()
        }
        
        // When
        sut.saveProfile(profileUpdate, profileId: "1")
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
