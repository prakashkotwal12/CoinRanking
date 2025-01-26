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
    func testConvertDomainModelToUIModel_WithValidIconURL() {
        let domainModel = CoinDomainModel(
            uuid: "1",
            symbol: "BTC",
            name: "Bitcoin",
            color: "#f7931A",
            iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
            marketCap: "2080953348713",
            price: "105016.99530574532",
            t24hVolume: "16362960914",
            change: "0.18",
            rank: 1,
            sparkline: ["104681.48219255316", "105006.47780060928", "105065.20301457435"],
            listedAt: 1330214400,
            tier: 1,
            lowVolume: false,
            coinrankingUrl: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc",
            btcPrice: "1",
            contractAddresses: []
        )
        let uiModel = CoinUIModel(from: domainModel)
        
        XCTAssertEqual(uiModel.id, domainModel.uuid)
        XCTAssertEqual(uiModel.name, domainModel.name)
        XCTAssertEqual(uiModel.iconURL?.absoluteString, domainModel.iconUrl)
    }
    
    func testConvertDomainModelToUIModel_WithEmptyIconURL() {
        let domainModel = CoinDomainModel(
            uuid: "2",
            symbol: "ETH",
            name: "Ethereum",
            color: "#3C3C3D",
            iconUrl: "", // Empty iconUrl
            marketCap: "402617677068",
            price: "3340.9950139293824",
            t24hVolume: "9279253653",
            change: "0.04",
            rank: 2,
            sparkline: ["3338.453319952191", "3341.427852271922", "3340.5937656290657"],
            listedAt: 1438905600,
            tier: 1,
            lowVolume: false,
            coinrankingUrl: "https://coinranking.com/coin/razxDUgYGNAdQ+ethereum-eth",
            btcPrice: "0.03181385074103907",
            contractAddresses: []
        )
        let uiModel = CoinUIModel(from: domainModel)
        
        XCTAssertEqual(uiModel.id, domainModel.uuid)
        XCTAssertEqual(uiModel.name, domainModel.name)
        XCTAssertNil(uiModel.iconURL) // Expecting nil since iconUrl is empty
    }    
}
