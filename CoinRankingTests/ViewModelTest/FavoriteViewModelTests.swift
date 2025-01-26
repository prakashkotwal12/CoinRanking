//
//  FavoriteViewModelTests.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
import XCTest
@testable import CoinRanking

final class FavoriteViewModelTests: XCTestCase {
    var viewModel: FavoriteViewModel!
    var mockRepository: MockCoinRepository!
    var reloadTableCalled: Bool!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCoinRepository()
        viewModel = FavoriteViewModel(repository: mockRepository)
        reloadTableCalled = false
        viewModel.reloadTable = { [weak self] in
            self?.reloadTableCalled = true
        }
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        reloadTableCalled = nil
        super.tearDown()
    }
    
    func testFetchFavorites() {
        mockRepository.favorites = [
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: nil, iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: [], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [])
        ]
        
        viewModel.fetchFavorites()
        
        XCTAssertEqual(viewModel.favorites.count, 1)
        XCTAssertEqual(viewModel.favorites.first?.name, "Bitcoin")
        XCTAssertTrue(reloadTableCalled, "reloadTable should be called after fetching favorites")
    }
    
    func testUnfavoriteCoin() {
        mockRepository.favorites = [
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: nil, iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: [], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [])
        ]
        viewModel.fetchFavorites()
        viewModel.unfavorite(uuid: "1")
        
        XCTAssertTrue(viewModel.favorites.isEmpty, "Favorites list should be empty after unfavoriting the coin")
        XCTAssertTrue(reloadTableCalled, "reloadTable should be called after unfavoriting a coin")
    }
    
    func testFetchEmptyFavorites() {
        mockRepository.favorites = []
        
        viewModel.fetchFavorites()
        
        XCTAssertTrue(viewModel.favorites.isEmpty, "Favorites list should be empty when no favorites are fetched")
        XCTAssertTrue(reloadTableCalled, "reloadTable should be called even when the favorites list is empty")
    }
    
    func testUnfavoriteNonExistentCoin() {
        mockRepository.favorites = [
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: nil, iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: [], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [])
        ]
        viewModel.fetchFavorites()
        viewModel.unfavorite(uuid: "2") // Trying to remove a non-existent coin
        
        XCTAssertEqual(viewModel.favorites.count, 1, "Favorites list should remain unchanged when trying to remove a non-existent coin")
        XCTAssertEqual(viewModel.favorites.first?.id, "1", "The existing coin should not be removed")
        XCTAssertTrue(reloadTableCalled, "reloadTable should be called even when trying to remove a non-existent coin")
    }
    
    func testNotificationPostedOnUnfavorite() {
        mockRepository.favorites = [
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: nil, iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: [], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [])
        ]
        viewModel.fetchFavorites()
        
        let expectation = self.expectation(forNotification: .favoriteRemoved, object: nil) { notification -> Bool in
            guard let userInfo = notification.userInfo as? [String: String] else { return false }
            return userInfo["uuid"] == "1"
        }
        
        viewModel.unfavorite(uuid: "1")
        
        wait(for: [expectation], timeout: 1.0)
    }
}
