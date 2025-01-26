//
//  CoinRepositoryProtocol.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
protocol CoinRepositoryProtocol {
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinDataModel, APIError>) -> Void)
    func saveFavorite(_ coin: CoinDomainModel)
    func removeFavorite(uuid: String)
    func fetchFavorites() -> [CoinDomainModel]
    func isFavorite(uuid: String) -> Bool
}
