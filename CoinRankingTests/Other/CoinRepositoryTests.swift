//
//  CoinRepositoryTests.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import XCTest
import CoreData
@testable import CoinRanking

final class CoinRepositoryTests: XCTestCase {
    var repository: CoinRepository!
    var mockNetworkManager: MockCoinNetworkManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockCoinNetworkManager()
        mockCoreDataManager = MockCoreDataManager()
        repository = CoinRepository(network: mockNetworkManager, coreData: mockCoreDataManager)
    }
    
    override func tearDown() {
        repository = nil
        mockNetworkManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testFetchCoinsSuccess() {
        mockNetworkManager.shouldReturnError = false
        let expectation = self.expectation(description: "Fetch coins successfully")
        
        repository.fetchCoins(limit: 20, offset: 0) { result in
            switch result {
                case .success(let coinData):
                    XCTAssertEqual(coinData.coins.count, 2)
                    XCTAssertEqual(coinData.coins.first?.name, "Bitcoin")
                    expectation.fulfill()
                case .failure:
                    XCTFail("Expected success, but got failure.")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchCoinsFailure() {
        mockNetworkManager.shouldReturnError = true
        let expectation = self.expectation(description: "Fetch coins failed")
        
        repository.fetchCoins(limit: 20, offset: 0) { result in
            switch result {
                case .success:
                    XCTFail("Expected failure, but got success.")
                case .failure(let error):
                    XCTAssertEqual(error, .serverError("Mock error occurred"))
                    expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testSaveFavorite() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        
        repository.saveFavorite(coin)
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouritesCoins")
        let results = try? mockCoreDataManager.context.fetch(fetchRequest)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.value(forKey: "uuid") as? String, "1")
    }
    
    func testRemoveFavorite() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        
        repository.saveFavorite(coin)
        repository.removeFavorite(uuid: "1")
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouritesCoins")
        let results = try? mockCoreDataManager.context.fetch(fetchRequest)
        XCTAssertTrue(results?.isEmpty ?? false)
    }
    
    func testFetchFavorites() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        
        repository.saveFavorite(coin)
        let favorites = repository.fetchFavorites()
        
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.uuid, "1")
    }
    
    func testIsFavorite() {
        let coin = CoinDomainModel(uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: [], isFavorite: false)
        
        repository.saveFavorite(coin)
        let isFavorite = repository.isFavorite(uuid: "1")
        
        XCTAssertTrue(isFavorite)
    }    
}
