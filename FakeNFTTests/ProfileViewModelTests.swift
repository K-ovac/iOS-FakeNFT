//
//  ProfileViewModelTests.swift
//  FakeNFTTests
//
//  Created by Воробьева Юлия on 05.04.2026.
//

@testable import FakeNFT
import XCTest

final class ProfileViewModelTests: XCTestCase {
    
    var sut: ProfileViewModel!
    var mockProfileService: MockProfileService!
    var mockNavigationHandler: MockProfileNavigationHandler!
    
    override func setUp() {
        super.setUp()
        mockProfileService = MockProfileService()
        mockNavigationHandler = MockProfileNavigationHandler()
        sut = ProfileViewModel(profileService: mockProfileService)
        sut.setNavigationHandler(mockNavigationHandler)
    }
    
    override func tearDown() {
        sut = nil
        mockProfileService = nil
        mockNavigationHandler = nil
        super.tearDown()
    }
    
    // MARK: - Test fetchProfile
    
    func testFetchProfile_Success_UpdatesProfile() {
        // Given
        let expectedProfile = Profile(
            name: "Test User",
            avatar: "https://example.com/avatar.jpg",
            description: "Test description",
            website: "https://example.com",
            nfts: ["nft1", "nft2"],
            likes: ["like1"],
            id: "1"
        )
        mockProfileService.loadProfileResult = .success(expectedProfile)
        
        let expectation = XCTestExpectation(description: "Profile loaded")
        sut.onDataChange = {
            expectation.fulfill()
        }
        
        // When
        sut.fetchProfile()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.profile?.name, "Test User")
        XCTAssertEqual(sut.nftsCount, 2)
        XCTAssertEqual(sut.likesCount, 1)
    }
    
    func testFetchProfile_Failure_CallsOnError() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 404)
        mockProfileService.loadProfileResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Error called")
        sut.onError = { errorMessage in
            expectation.fulfill()
        }
        
        // When
        sut.fetchProfile()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(sut.profile)
    }
    
    // MARK: - Test Navigation
    
    func testEditProfile_CallsNavigateToEditProfile() {
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
        mockProfileService.loadProfileResult = .success(profile)
        
        let expectation = XCTestExpectation(description: "Profile loaded")
        sut.onDataChange = {
            expectation.fulfill()
        }
        sut.fetchProfile()
        wait(for: [expectation], timeout: 1.0)
        
        // When
        sut.editProfile()
        
        // Then
        XCTAssertTrue(mockNavigationHandler.navigateToEditProfileCalled)
        XCTAssertNotNil(mockNavigationHandler.passedProfile)
    }
    
    func testShowMyNFTs_CallsNavigateToMyNFTs() {
        // Given
        let profile = Profile(
            name: "Test User",
            avatar: "https://example.com/avatar.jpg",
            description: "Test",
            website: "https://example.com",
            nfts: ["nft1", "nft2"],
            likes: [],
            id: "1"
        )
        mockProfileService.loadProfileResult = .success(profile)
        
        let expectation = XCTestExpectation(description: "Profile loaded")
        sut.onDataChange = {
            expectation.fulfill()
        }
        sut.fetchProfile()
        wait(for: [expectation], timeout: 1.0)
        
        // When
        sut.showMyNFTs()
        
        // Then
        XCTAssertTrue(mockNavigationHandler.navigateToMyNFTsCalled)
        XCTAssertEqual(mockNavigationHandler.passedNftIds, ["nft1", "nft2"])
    }
    
    func testShowFavorites_CallsNavigateToFavorites() {
        // Given
        let profile = Profile(
            name: "Test User",
            avatar: "https://example.com/avatar.jpg",
            description: "Test",
            website: "https://example.com",
            nfts: [],
            likes: ["like1", "like2"],
            id: "1"
        )
        mockProfileService.loadProfileResult = .success(profile)
        
        let expectation = XCTestExpectation(description: "Profile loaded")
        sut.onDataChange = {
            expectation.fulfill()
        }
        sut.fetchProfile()
        wait(for: [expectation], timeout: 1.0)
        
        // When
        sut.showFavorites()
        
        // Then
        XCTAssertTrue(mockNavigationHandler.navigateToFavoritesCalled)
        XCTAssertEqual(mockNavigationHandler.passedFavoriteIds, ["like1", "like2"])
    }
}
