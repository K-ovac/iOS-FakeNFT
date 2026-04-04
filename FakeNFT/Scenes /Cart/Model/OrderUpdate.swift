//
//  OrderUpdate.swift
//  FakeNFT
//
//  Created by Максим Лозебной on 04.04.2026.
//

struct OrderUpdate: Encodable {
    let nfts: [String]
}

struct OrderUpdateDto: Dto {
    let orderUpdate: OrderUpdate
    let dictKey: String = "nfts"
    
    func asDictionary() -> [String: String] {
        var dictionary: [String: String] = [:]
        if !orderUpdate.nfts.isEmpty {
            dictionary[dictKey] = orderUpdate.nfts.joined(separator: ",")
        }
        
        return dictionary
    }
}
