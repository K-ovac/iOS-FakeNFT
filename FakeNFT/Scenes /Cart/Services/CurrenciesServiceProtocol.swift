//
//  CurrenciesServiceProtocol.swift
//  FakeNFT
//
//  Created by Аркадий Червонный on 09.04.2026.
//

import Foundation

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void

protocol CurrenciesServiceProtocol {
    func loadCurrencies(completion: @escaping CurrenciesCompletion)
}
