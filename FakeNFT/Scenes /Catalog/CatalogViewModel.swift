//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 25.03.2026.
//
import Foundation

// MARK: - Sort Type
enum CatalogSortType: String {
    case byName, byNftsCount
}

// MARK: - State

enum CatalogState {
    case initial
    case loading
    case data([Catalog])
    case failed(Error)
}

// MARK: - CatalogViewModel

final class CatalogViewModel {
    
    // MARK: - Closures
    
    var onSelectedNftCollection: ((Catalog) -> Void)?
    var onFetchedNftCollection: (() -> Void)?
    var onError: ((ErrorModel) -> Void)?
    var onLoadingStarted: (() -> Void)?
    var onLoadingStopped: (() -> Void)?
    
    // MARK: - Properties
    
    private var catalogService: CatalogService
    private var nftCollections: [Catalog] = [] {
        didSet {
            onFetchedNftCollection?()
        }
    }
    
    private var currentSortType: CatalogSortType = UserDefaultsService.shared.getCategorySort() {
        didSet {
            UserDefaultsService.shared.setCategorySort(for: currentSortType)
            completeSorting()
        }
    }
    
    private var state: CatalogState = .initial {
        didSet {
            stateDidChanged()
        }
    }
    
    //MARK: - Init
    
    init(catalogService: CatalogService) {
        self.catalogService = catalogService

    }
    
    // MARK: - Factory Methods
    
    func numberOfRows() -> Int {
        nftCollections.count
    }
    
    func nftCollection(at index: Int) -> Catalog {
        nftCollections[index]
    }
    
    // MARK: - Select NFT Collection
    
    func selectNftCollection(at index: Int) {
        let nftCollection = nftCollections[index]
        onSelectedNftCollection?(nftCollection)
    }
    
    // MARK: - Fetch NFT Collections
    
    func fetchNftCollections() {
        state = .loading
        catalogService.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let catalogNftCollections):
                    print("Загружен каталог Nft коллекций: ", catalogNftCollections.count)
                    self?.state = .data(catalogNftCollections)
                case .failure(let error):
                    print(error)
                    self?.state = .failed(error)
                }
            }
        }
    }
    
    // MARK: - Sort
    
    func completeSorting() {
        switch currentSortType {
        case .byName:
            nftCollections.sort { $0.name < $1.name }
        case .byNftsCount:
            nftCollections.sort { $0.nfts.count > $1.nfts.count }
        }
    }
    
    func sortByName() {
        currentSortType = .byName
        print("Отсортировано по Имени")
    }
    
    func sortByNftsCount() {
        currentSortType = .byNftsCount
        print("Отсортировано по количеству NFT")
    }
    
    // MARK: - Private Methods
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            break
        case .loading:
            onLoadingStarted?()
        case .data(let collections):
            nftCollections = collections
            completeSorting()
            onLoadingStopped?()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            onLoadingStopped?()
            onError?(errorModel)
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.fetchNftCollections()
        }
    }
}
