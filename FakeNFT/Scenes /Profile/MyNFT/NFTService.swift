//
//  NFTService.swift
//  FakeNFT
//
//  Created by Воробьева Юлия on 26.03.2026.
//

import Foundation

typealias NFTListCompletion = (Result<[NFT], Error>) -> Void
typealias NFTAuthorCompletion = (Result<NFTAuthor, Error>) -> Void

protocol NFTListService {
    func loadNFTs(ids: [String], completion: @escaping NFTListCompletion)
    func loadAuthor(id: String, completion: @escaping NFTAuthorCompletion)
}

final class NFTListServiceImpl: NFTListService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadNFTs(ids: [String], completion: @escaping NFTListCompletion) {
        let group = DispatchGroup()
        var nfts: [NFT] = []
        var errors: [Error] = []
        
        for id in ids {
            group.enter()
            let request = NFTRequest(id: id)
            networkClient.send(request: request, type: NFT.self) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if !errors.isEmpty {
                completion(.failure(errors.first!))
            } else {
                completion(.success(nfts))
            }
        }
    }
    
    func loadAuthor(id: String, completion: @escaping NFTAuthorCompletion) {
        let request = NFTAuthorRequest(id: id)
        networkClient.send(request: request, type: NFTAuthor.self) { result in
            switch result {
            case .success(let author):
                completion(.success(author))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct NFTAuthorRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var dto: Dto? {
        return nil
    }
}
