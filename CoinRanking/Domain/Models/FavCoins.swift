//
//  FavCoins.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
struct FavCoins: Codable {
    let image: String
    let price: String
    let uuid: String
    let name: String
    let sparkline: [String?]
}
