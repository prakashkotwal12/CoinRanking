//
//  CoinModelConversionTests.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//
import Foundation
import XCTest
@testable import CoinRanking

final class CoinModelConversionTests: XCTestCase {
    func testConvertDomainModelToUIModel() {
        let domainModel = CoinDomainModel(
            uuid: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconUrl: "https://example.com/icon.png", marketCap: "1000", price: "50000", t24hVolume: "200", change: "5", rank: 1, sparkline: ["50000"], listedAt: 1, tier: 1, lowVolume: false, coinrankingUrl: "", btcPrice: "1", contractAddresses: []
        )
        let uiModel = CoinUIModel(from: domainModel)
        
        XCTAssertEqual(uiModel.id, domainModel.uuid)
        XCTAssertEqual(uiModel.name, domainModel.name)
        XCTAssertEqual(uiModel.iconURL?.absoluteString, domainModel.iconUrl)
    }
    
    func testConvertUIModelToDomainModel() {
        let uiModel = CoinUIModel(
            id: "1", symbol: "BTC", name: "Bitcoin", color: "#f7931A", iconURL: URL(string: ""), marketCap: "1000", price: "50000", volume24h: "200", change: "5", changePercentage: "5", rank: 1, sparkline: ["50000"], listedAt: "Jan 1, 2021", tier: "Tier 1", lowVolume: false, coinRankingURL: URL(string: ""), btcPrice: "1", contractAddresses: [], isFavorite: false
        )
        
        let domainModel = CoinDomainModel(from: uiModel)
        
        XCTAssertEqual(domainModel.uuid, uiModel.id)
        XCTAssertEqual(domainModel.name, uiModel.name)
        XCTAssertEqual(domainModel.iconUrl, uiModel.iconURL?.absoluteString ?? "")
    }    
}
