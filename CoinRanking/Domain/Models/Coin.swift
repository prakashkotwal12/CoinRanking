//
//  Coin.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation

// MARK: - Models
struct CoinResponseModel: Codable {
    let status: String
    let data: CoinData
}

struct CoinData: Codable {
    let stats: Stats
    let coins: [Coin]
}

struct Coin: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let color: String?
    let iconUrl: String
    let marketCap: String
    let price: String
    let t24hVolume: String
    let change: String
    let rank: Int
    let sparkline: [String?]
    let listedAt: Int
    let tier: Int
    let lowVolume: Bool
    let coinrankingUrl: String
    let btcPrice: String
    let contractAddresses: [String]

    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, rank, sparkline, listedAt, tier, lowVolume, coinrankingUrl, btcPrice, contractAddresses
        case t24hVolume = "24hVolume"
        case change = "change"
    }
}

struct Stats: Codable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
}
