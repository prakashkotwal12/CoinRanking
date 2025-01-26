//
//  MockCoinNetworkManager.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
@testable import CoinRanking

final class MockCoinNetworkManager: CoinNetworkManagerProtocol {
    var shouldReturnError = false
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinDataModel, APIError>) -> Void) {
        if shouldReturnError {
            completion(.failure(.serverError("Mock error occurred")))
        } else {
            let mockCoins = [
                CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false),
                CoinDomainModel(uuid: "2", symbol: "ETH", name: "Ethereum", color: "#3c3c3d", iconUrl: "", marketCap: "800", price: "2000", t24hVolume: "100", change: "3", rank: 2, sparkline: ["2000"], listedAt: 2, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "0.5", contractAddresses: [], isFavorite: false)
            ]
            let mockStats = StatsModel(
                total: mockCoins.count,
                totalCoins: mockCoins.count,
                totalMarkets: 1000,
                totalExchanges: 100,
                totalMarketCap: "1000000",
                total24hVolume: "50000"
            )
            let mockData = CoinDataModel(stats: mockStats, coins: mockCoins)
            completion(.success(mockData))
        }
    }    
}
