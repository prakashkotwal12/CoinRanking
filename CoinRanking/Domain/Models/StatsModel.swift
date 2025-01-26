//
//  StatsModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation

struct StatsModel: Codable {
    let total: Int
    let totalCoins: Int
    let totalMarkets: Int
    let totalExchanges: Int
    let totalMarketCap: String
    let total24hVolume: String
    
    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap, total24hVolume
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            total = try container.decode(Int.self, forKey: .total)
        } catch {
            print("❌ Error decoding 'total': \(error.localizedDescription)")
            throw error
        }
        
        do {
            totalCoins = try container.decode(Int.self, forKey: .totalCoins)
        } catch {
            print("❌ Error decoding 'totalCoins': \(error.localizedDescription)")
            throw error
        }
        
        do {
            totalMarkets = try container.decode(Int.self, forKey: .totalMarkets)
        } catch {
            print("❌ Error decoding 'totalMarkets': \(error.localizedDescription)")
            throw error
        }
        
        do {
            totalExchanges = try container.decode(Int.self, forKey: .totalExchanges)
        } catch {
            print("❌ Error decoding 'totalExchanges': \(error.localizedDescription)")
            throw error
        }
        
        do {
            totalMarketCap = try container.decode(String.self, forKey: .totalMarketCap)
        } catch {
            print("❌ Error decoding 'totalMarketCap': \(error.localizedDescription)")
            throw error
        }
        
        do {
            total24hVolume = try container.decode(String.self, forKey: .total24hVolume)
        } catch {
            print("❌ Error decoding 'total24hVolume': \(error.localizedDescription)")
            throw error
        }
    }    
}
