//
//  CoinDetailViewModel.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
import XCTest
@testable import CoinRanking

final class CoinDetailViewModelTests: XCTestCase {
    var viewModel: CoinDetailViewModel!
    
    override func setUp() {
        super.setUp()
        
        let testCoinDomainModel = CoinDomainModel(
            uuid: "1",
            symbol: "BTC",
            name: "Bitcoin",
            color: nil,
            iconUrl: "",
            marketCap: "1000",
            price: "50000",
            t24hVolume: "200",
            change: "5",
            rank: 1,
            sparkline: ["50000", "51000", "52000"],
            listedAt: 1,
            tier: 1,
            lowVolume: false,
            coinrankingUrl: "",
            btcPrice: "1",
            contractAddresses: []
        )
        
        let testCoinUIModel = CoinUIModel(from: testCoinDomainModel)
        viewModel = CoinDetailViewModel(coin: testCoinUIModel)
    }
    
    func testFilterData24h() {
        XCTAssertEqual(viewModel.filteredSparkline.count, 3)
    }
    
    func testFilterData7d() {
        viewModel.filterData(for: "7d")
        XCTAssertEqual(viewModel.filteredSparkline.count, 3)
    }
    
    func testFilterData30d() {
        viewModel.filterData(for: "30d")
        XCTAssertEqual(viewModel.filteredSparkline.count, 3)
    }    
}
