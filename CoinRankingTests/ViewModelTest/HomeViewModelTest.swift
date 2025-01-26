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
    var mockRepository: MockCoinRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCoinRepository()
        viewModel = HomeViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchCoinsSuccess() {
        mockRepository.coins = [
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        ]
        viewModel.fetchCoins()
        
        XCTAssertEqual(viewModel.uiCoins.count, 1)
        XCTAssertEqual(viewModel.uiCoins.first?.name, "Bitcoin")
    }
    
    func testFetchCoinsFailure() {
        mockRepository.shouldReturnError = true
        viewModel.fetchCoins()
        
        XCTAssertTrue(viewModel.uiCoins.isEmpty)
    }
    
    func testApplyFilterByName() {
        mockRepository.coins = [
            CoinDomainModel(uuid: "2", symbol: "ETH", name: "Ethereum", color: "#3c3c3d", iconUrl: "", marketCap: "800", price: "2000", t24hVolume: "100", change: "3", rank: 2, sparkline: ["2000"], listedAt: 2, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false),
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        ]
        viewModel.fetchCoins()
        viewModel.selectedFilter = .name
        viewModel.applyFilter()
        
        XCTAssertEqual(viewModel.uiCoins.first?.name, "Bitcoin")
    }
    
    func testFavoriteCoin() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        mockRepository.coins = [coin]
        viewModel.fetchCoins()
        let uiCoin = viewModel.uiCoins.first!
        viewModel.favorite(coin: uiCoin)
        
        XCTAssertTrue(viewModel.isFavorite(uuidString: coin.uuid))
        XCTAssertTrue(viewModel.uiCoins.first?.isFavorite ?? false)
    }
    
    func testUnfavoriteCoin() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        mockRepository.coins = [coin]
        viewModel.fetchCoins()
        let uiCoin = viewModel.uiCoins.first!
        
        viewModel.favorite(coin: uiCoin)
        viewModel.unfavorite(uuid: uiCoin.id)
        
        XCTAssertFalse(viewModel.isFavorite(uuidString: coin.uuid))
        XCTAssertFalse(viewModel.uiCoins.first?.isFavorite ?? true)
    }
    
    func testResetFilter() {
        mockRepository.coins = [
            CoinDomainModel(uuid: "2", symbol: "ETH", name: "Ethereum", color: "#3c3c3d", iconUrl: "", marketCap: "800", price: "2000", t24hVolume: "100", change: "3", rank: 2, sparkline: ["2000"], listedAt: 2, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false),
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        ]
        
        viewModel.fetchCoins()
        viewModel.selectedFilter = .price
        viewModel.applyFilter()
        viewModel.resetFilter()
        
        XCTAssertEqual(viewModel.uiCoins.count, 2)
        XCTAssertEqual(viewModel.uiCoins.first?.name, "Bitcoin")
    }
    
    func testHandleFavoriteChange() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: true)
        mockRepository.coins = [coin]
        viewModel.fetchCoins()
        
        NotificationCenter.default.post(name: .favoriteRemoved, object: nil, userInfo: ["uuid": coin.uuid])
        
        XCTAssertFalse(viewModel.isFavorite(uuidString: coin.uuid))
        XCTAssertFalse(viewModel.uiCoins.first?.isFavorite ?? true)
    }
    
    func testLoadNextPage() {
        mockRepository.coins = [
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        ]
        
        viewModel.fetchCoins()
        XCTAssertEqual(viewModel.uiCoins.count, 1)
        
        mockRepository.coins = [
            CoinDomainModel(uuid: "2", symbol: "ETH", name: "Ethereum", color: "#3c3c3d", iconUrl: "", marketCap: "800", price: "2000", t24hVolume: "100", change: "3", rank: 2, sparkline: ["2000"], listedAt: 2, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        ]
        
        viewModel.loadNextPage {
            XCTAssertEqual(self.viewModel.uiCoins.count, 2)
            XCTAssertEqual(self.viewModel.uiCoins.last?.name, "Ethereum")
        }
    }
    
    func testApplyFilter() {
        mockRepository.coins = [
            CoinDomainModel(uuid: "2", symbol: "ETH", name: "Ethereum", color: "#3c3c3d", iconUrl: "", marketCap: "800", price: "2000", t24hVolume: "100", change: "3", rank: 2, sparkline: ["2000"], listedAt: 2, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false),
            CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        ]
        viewModel.fetchCoins()

        // Test name filter
        viewModel.selectedFilter = .name
        viewModel.selectedSortOrder = .ascending
        viewModel.applyFilter()
        XCTAssertEqual(viewModel.uiCoins.first?.name, "Bitcoin")
        XCTAssertEqual(viewModel.uiCoins.last?.name, "Ethereum")

        // Test price filter
        viewModel.selectedFilter = .price
        viewModel.selectedSortOrder = .descending
        viewModel.applyFilter()
        XCTAssertEqual(viewModel.uiCoins.first?.price, "50000")
        XCTAssertEqual(viewModel.uiCoins.last?.price, "2000")

        // Test 24hVolume filter
        viewModel.selectedFilter = .performance
        viewModel.selectedSortOrder = .ascending
        viewModel.applyFilter()
        XCTAssertEqual(viewModel.uiCoins.first?.volume24h, "100")
        XCTAssertEqual(viewModel.uiCoins.last?.volume24h, "200")
    }
}
