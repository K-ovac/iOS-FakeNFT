//
//  MyNFTsViewModel.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 26.03.2026.
//


import Foundation

protocol MyNFTsViewModelProtocol: AnyObject {
    var nfts: [NFTDisplayModel] { get }
    var onDataChange: (() -> Void)? { get set }
    var onLoadingStateChange: ((Bool) -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    
    func fetchNFTs()
    func sortByRating()
    func sortByName()
    func sortByPrice()
}

final class MyNFTsViewModel: MyNFTsViewModelProtocol {
    var nfts: [NFTDisplayModel] = [] {
        didSet {
            onDataChange?()
        }
    }
    
    var onDataChange: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    private let nftIds: [String]
    private let nftService: NFTListService
    private var currentSortType: SortType = .name
    private var authorsCache: [String: String] = [:]
    
    enum SortType: String {
        case name = "name"
        case price = "price"
        case rating = "rating"
    }
    
    init(nftIds: [String]) {
        self.nftIds = nftIds
        self.nftService = NFTListServiceImpl(networkClient: DefaultNetworkClient())
        loadSortPreference()
    }
    
    func fetchNFTs() {
        guard !nftIds.isEmpty else {
            nfts = []
            return
        }
        
        onLoadingStateChange?(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.nftService.loadNFTs(ids: self?.nftIds ?? []) { result in
                DispatchQueue.main.async {
                    self?.onLoadingStateChange?(false)
                    
                    switch result {
                    case .success(let nfts):
                        self?.processNFTs(nfts)
                    case .failure(let error):
                        self?.onError?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func processNFTs(_ nfts: [NFT]) {
        let group = DispatchGroup()
        var displayModels: [NFTDisplayModel] = []
        
        for nft in nfts {
            group.enter()
            
            if let cachedAuthor = authorsCache[nft.author] {
                let displayModel = NFTDisplayModel(
                    id: nft.id,
                    name: nft.name,
                    imageUrl: nft.images.first,
                    rating: nft.rating,
                    price: nft.price,
                    author: cachedAuthor
                )
                displayModels.append(displayModel)
                group.leave()
            } else {
                nftService.loadAuthor(id: nft.author) { [weak self] result in
                    defer { group.leave() }
                    
                    switch result {
                    case .success(let author):
                        self?.authorsCache[nft.author] = author.name
                        let displayModel = NFTDisplayModel(
                            id: nft.id,
                            name: nft.name,
                            imageUrl: nft.images.first,
                            rating: nft.rating,
                            price: nft.price,
                            author: author.name
                        )
                        displayModels.append(displayModel)
                    case .failure:
                        let displayModel = NFTDisplayModel(
                            id: nft.id,
                            name: nft.name,
                            imageUrl: nft.images.first,
                            rating: nft.rating,
                            price: nft.price,
                            author: "Unknown"
                        )
                        displayModels.append(displayModel)
                    }
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.nfts = displayModels
            self?.applySort()
        }
    }
    
    func sortByRating() {
        currentSortType = .rating
        saveSortPreference()
        applySort()
    }
    
    func sortByName() {
        currentSortType = .name
        saveSortPreference()
        applySort()
    }
    
    func sortByPrice() {
        currentSortType = .price
        saveSortPreference()
        applySort()
    }
    
    private func applySort() {
        switch currentSortType {
        case .rating:
            nfts.sort { $0.rating > $1.rating }
        case .name:
            nfts.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .price:
            nfts.sort { $0.price < $1.price }
        }
    }
    
    private func saveSortPreference() {
        UserDefaults.standard.set(currentSortType.rawValue, forKey: "my_nfts_sort_type")
    }
    
    private func loadSortPreference() {
        if let savedValue = UserDefaults.standard.string(forKey: "my_nfts_sort_type"),
           let savedType = SortType(rawValue: savedValue) {
            currentSortType = savedType
        }
    }
}
