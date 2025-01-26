//
//  CoinData.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
struct CoinDataModel: Codable {
    let stats: StatsModel
    let coins: [CoinDomainModel]
    
    enum CodingKeys: String, CodingKey {
        case stats, coins
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            stats = try container.decode(StatsModel.self, forKey: .stats)
        } catch {
            print("❌ Error decoding 'stats': \(error.localizedDescription)")
            throw error
        }
        
        do {
            coins = try container.decode([CoinDomainModel].self, forKey: .coins)
        } catch {
            print("❌ Error decoding 'coins': \(error.localizedDescription)")
            throw error
        }
    }    
}
