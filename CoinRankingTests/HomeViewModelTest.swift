//
//  HomeViewModelTest.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import XCTest
@testable import CoinRanking

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockRepo: MockCoinRepository!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockCoinRepository()
        viewModel = HomeViewModel(repository: mockRepo)
    }
    
    func testFetchCoins() {
        XCTAssertEqual(viewModel.coins.count, 0)
        viewModel.fetchCoins()
        XCTAssertEqual(viewModel.coins.count, 2)  // from mock
    }
    
    func testFilterHighestPrice() {
        viewModel.fetchCoins()
        viewModel.applyFilterHighestPrice()
        // check order
        let firstPrice = Double(viewModel.coins.first?.price ?? "0") ?? 0
        let secondPrice = Double(viewModel.coins.last?.price ?? "0") ?? 0
        XCTAssertTrue(firstPrice >= secondPrice)
    }
}

// Mock
final class MockCoinRepository: CoinRepositoryProtocol {
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        let coin1 = Coin(uuid: "1", symbol: "BTC", name: "Bitcoin", iconUrl: "", marketCap: "", price: "100", t24hVolume: "200", sparkline: [])
        let coin2 = Coin(uuid: "2", symbol: "ETH", name: "Ethereum", iconUrl: "", marketCap: "", price: "50", t24hVolume: "150", sparkline: [])
        completion(.success([coin1, coin2]))
    }
    func saveFavorite(_ coin: Coin) { }
    func removeFavorite(uuid: String) { }
    func fetchFavorites() -> [FavCoins] { return [] }
    func isFavorite(uuid: String) -> Bool { return false }
}
