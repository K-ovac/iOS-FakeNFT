//
//  FavoritesNFTViewModelTests.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 05.04.2026.
//


@testable import FakeNFT
import XCTest

final class FavoritesNFTViewModelTests: XCTestCase {
    
    var sut: FavoritesNFTViewModel!
    var mockNFTService: MockNFTListService!
    var mockProfileService: MockProfileService!
    
    override func setUp() {
        super.setUp()
        mockNFTService = MockNFTListService()
        mockProfileService = MockProfileService()
        sut = FavoritesNFTViewModel(
            favoriteIds: ["nft1", "nft2"],
            nftService: mockNFTService,
            profileService: mockProfileService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNFTService = nil
        mockProfileService = nil
        super.tearDown()
    }
    
    // MARK: - Test fetchFavorites
    
    func testFetchFavorites_Success_LoadsNFTs() {
        // Given
        let expectedNFTs = [
            NFT(id: "nft1", name: "NFT 1", images: [URL(string: "https://example.com/1.jpg")!], rating: 4, price: 100, author: "author1", createdAt: nil),
            NFT(id: "nft2", name: "NFT 2", images: [URL(string: "https://example.com/2.jpg")!], rating: 5, price: 200, author: "author2", createdAt: nil)
        ]
        mockNFTService.loadNFTsResult = .success(expectedNFTs)
        
        let expectation = XCTestExpectation(description: "NFTs loaded")
        sut.onDataChange = {
            expectation.fulfill()
        }
        
        // When
        sut.fetchFavorites()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.nfts.count, 2)
        XCTAssertEqual(sut.nfts.first?.name, "NFT 1")
        XCTAssertEqual(sut.nfts.last?.price, 200)
    }
    
    func testFetchFavorites_EmptyIds_ReturnsEmptyArray() {
        // Given
        sut = FavoritesNFTViewModel(
            favoriteIds: [],
            nftService: mockNFTService,
            profileService: mockProfileService
        )
        
        // When
        sut.fetchFavorites()
        
        // Then
        XCTAssertTrue(sut.nfts.isEmpty)
    }
    
    func testFetchFavorites_Failure_CallsOnError() {
        // Given
        let expectedError = NSError(domain: "TestError", code: 500)
        mockNFTService.loadNFTsResult = .failure(expectedError)
        
        let expectation = XCTestExpectation(description: "Error called")
        sut.onError = { errorMessage in
            expectation.fulfill()
        }
        
        // When
        sut.fetchFavorites()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(sut.nfts.isEmpty)
    }
    
    // MARK: - Test removeFromFavorites
    
    func testRemoveFromFavorites_Success_RemovesNFT() {
        // Given
        let profile = Profile(
            name: "Test User",
            avatar: "https://example.com/avatar.jpg",
            description: "Test",
            website: "https://example.com",
            nfts: [],
            likes: ["nft1", "nft2"],
            id: "1"
        )
        mockProfileService.loadProfileResult = .success(profile)
        mockProfileService.updateProfileResult = .success(profile)
        
        let nfts = [
            NFT(id: "nft1", name: "NFT 1", images: [], rating: 4, price: 100, author: "author1", createdAt: nil),
            NFT(id: "nft2", name: "NFT 2", images: [], rating: 5, price: 200, author: "author2", createdAt: nil)
        ]
        mockNFTService.loadNFTsResult = .success(nfts)
        
        let loadExpectation = XCTestExpectation(description: "NFTs loaded")
        sut.onDataChange = {
            loadExpectation.fulfill()
        }
        sut.fetchFavorites()
        wait(for: [loadExpectation], timeout: 1.0)
        
        let removeExpectation = XCTestExpectation(description: "NFT removed")
        sut.onDataChange = {
            removeExpectation.fulfill()
        }
        
        // When
        sut.removeFromFavorites(nftId: "nft1")
        
        // Then
        wait(for: [removeExpectation], timeout: 1.0)
        XCTAssertEqual(sut.nfts.count, 1)
        XCTAssertEqual(sut.nfts.first?.id, "nft2")
    }
    
    func testRemoveFromFavorites_Failure_RestoresNFTs() {
        // Given
        let profile = Profile(
            name: "Test User",
            avatar: "https://example.com/avatar.jpg",
            description: "Test",
            website: "https://example.com",
            nfts: [],
            likes: ["nft1", "nft2"],
            id: "1"
        )
        mockProfileService.loadProfileResult = .success(profile)
        mockProfileService.updateProfileResult = .failure(NSError(domain: "UpdateError", code: 500))
        
        let nfts = [
            NFT(id: "nft1", name: "NFT 1", images: [], rating: 4, price: 100, author: "author1", createdAt: nil),
            NFT(id: "nft2", name: "NFT 2", images: [], rating: 5, price: 200, author: "author2", createdAt: nil)
        ]
        mockNFTService.loadNFTsResult = .success(nfts)
        
        let loadExpectation = XCTestExpectation(description: "NFTs loaded")
        sut.onDataChange = {
            loadExpectation.fulfill()
        }
        sut.fetchFavorites()
        wait(for: [loadExpectation], timeout: 1.0)
        
        let errorExpectation = XCTestExpectation(description: "Error called")
        sut.onError = { _ in
            errorExpectation.fulfill()
        }
        
        // When
        sut.removeFromFavorites(nftId: "nft1")
        
        // Then
        wait(for: [errorExpectation], timeout: 1.0)
    }
}
