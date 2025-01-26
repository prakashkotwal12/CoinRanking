//
//  MockCoinRepository.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//
import Foundation
@testable import CoinRanking

final class MockCoinRepository: CoinRepositoryProtocol {
    var coins: [CoinDomainModel] = []
    var favorites: [CoinDomainModel] = []
    var shouldReturnError: Bool = false
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinDataModel, APIError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.serverError("Mock error occurred")))
        } else {
            let mockStats = StatsModel(
                total: coins.count,
                totalCoins: coins.count,
                totalMarkets: 1000,
                totalExchanges: 100,
                totalMarketCap: "1000000",
                total24hVolume: "50000"
            )
            let mockData = CoinDataModel(stats: mockStats, coins: coins)
            completion(.success(mockData))
        }
    }
    
    func saveFavorite(_ coin: CoinDomainModel) {
        favorites.append(coin)
    }
    
    func removeFavorite(uuid: String) {
        favorites.removeAll { $0.uuid == uuid }
    }
    
    func fetchFavorites() -> [CoinDomainModel] {
        return favorites
    }
    
    func isFavorite(uuid: String) -> Bool {
        return favorites.contains(where: { $0.uuid == uuid })
    }
}
