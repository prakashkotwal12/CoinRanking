//
//  Coin.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation

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
    let iconUrl: String
    let marketCap: String
    let price: String
    let t24hVolume: String
    let sparkline: [String?]
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, iconUrl, marketCap, price, sparkline
        case t24hVolume = "24hVolume"
    }


    // ...
}

struct Stats: Codable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    // ...
}
