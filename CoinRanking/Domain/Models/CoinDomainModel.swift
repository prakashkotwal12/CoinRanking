//
//  Coin.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
//Separating the DataModel and UIModel ensures clear separation of concerns, aligning with MVVM best practices. The Model should remain independent of the UI layer, focusing solely on data and business logic, while the UIModel is used exclusively for interactions with the UI. This approach keeps the architecture clean and maintainable.
struct CoinDomainModel: Codable {
    let uuid: String
    let symbol: String
    let name: String
    let iconUrl: String
    let marketCap: String
    let price: String
    let t24hVolume: String
    let change: String
    let rank: Int
    let listedAt: Int
    let tier: Int
    let lowVolume: Bool
    let coinrankingUrl: String
    let btcPrice: String
    //optional values
    let color: String?
    let sparkline: [String]
    let contractAddresses: [String]
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, rank, sparkline, listedAt, tier, lowVolume, coinrankingUrl, btcPrice, contractAddresses
        case t24hVolume = "24hVolume"
        case change = "change"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            uuid = try container.decode(String.self, forKey: .uuid)
        } catch {
            print("❌ Error decoding 'uuid': \(error.localizedDescription)")
            throw error
        }
        
        do {
            symbol = try container.decode(String.self, forKey: .symbol)
        } catch {
            print("❌ Error decoding 'symbol': \(error.localizedDescription)")
            throw error
        }
        
        do {
            name = try container.decode(String.self, forKey: .name)
        } catch {
            print("❌ Error decoding 'name': \(error.localizedDescription)")
            throw error
        }
        
        do {
            iconUrl = try container.decode(String.self, forKey: .iconUrl)
        } catch {
            print("❌ Error decoding 'iconUrl': \(error.localizedDescription)")
            throw error
        }
        
        do {
            marketCap = try container.decode(String.self, forKey: .marketCap)
        } catch {
            print("❌ Error decoding 'marketCap': \(error.localizedDescription)")
            throw error
        }
        
        do {
            price = try container.decode(String.self, forKey: .price)
        } catch {
            print("❌ Error decoding 'price': \(error.localizedDescription)")
            throw error
        }
        
        do {
            t24hVolume = try container.decode(String.self, forKey: .t24hVolume)
        } catch {
            print("❌ Error decoding 't24hVolume': \(error.localizedDescription)")
            throw error
        }
        
        do {
            change = try container.decode(String.self, forKey: .change)
        } catch {
            print("❌ Error decoding 'change': \(error.localizedDescription)")
            throw error
        }
        
        do {
            rank = try container.decode(Int.self, forKey: .rank)
        } catch {
            print("❌ Error decoding 'rank': \(error.localizedDescription)")
            throw error
        }
        
        do {
            listedAt = try container.decode(Int.self, forKey: .listedAt)
        } catch {
            print("❌ Error decoding 'listedAt': \(error.localizedDescription)")
            throw error
        }
        
        do {
            tier = try container.decode(Int.self, forKey: .tier)
        } catch {
            print("❌ Error decoding 'tier': \(error.localizedDescription)")
            throw error
        }
        
        do {
            lowVolume = try container.decode(Bool.self, forKey: .lowVolume)
        } catch {
            print("❌ Error decoding 'lowVolume': \(error.localizedDescription)")
            throw error
        }
        
        do {
            coinrankingUrl = try container.decode(String.self, forKey: .coinrankingUrl)
        } catch {
            print("❌ Error decoding 'coinrankingUrl': \(error.localizedDescription)")
            throw error
        }
        
        do {
            btcPrice = try container.decode(String.self, forKey: .btcPrice)
        } catch {
            print("❌ Error decoding 'btcPrice': \(error.localizedDescription)")
            throw error
        }
        
        //optional values decoding
        do {
            let rawSparkline = try container.decodeIfPresent([String?].self, forKey: .sparkline) ?? []
            sparkline = rawSparkline.compactMap { $0 }  // filter out nil
        } catch {
            sparkline = []
        }
        
        do {
            let rawAddresses = try container.decodeIfPresent([String?].self, forKey: .contractAddresses) ?? []
            contractAddresses = rawAddresses.compactMap { $0 }
        } catch {
            contractAddresses = []
        }
        
        do {
            color = try container.decodeIfPresent(String.self, forKey: .color) ?? "#000000"
        } catch {
            print("❌ Error decoding 'color': \(error.localizedDescription)")
            color = "#000000"
        }
        
        isFavorite = false // default
    }    
}

extension CoinDomainModel {
    var priceAsCurrency: String {
        let priceDouble = Double(price) ?? 0
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: priceDouble as NSNumber) ?? price
    }
}

extension CoinDomainModel {
    init(from uiModel: CoinUIModel) {
        self.uuid = uiModel.id
        self.symbol = uiModel.symbol
        self.name = uiModel.name
        self.color = uiModel.color
        self.iconUrl = uiModel.iconURL?.absoluteString ?? ""
        self.marketCap = uiModel.marketCap
        self.price = uiModel.price
        self.t24hVolume = uiModel.volume24h
        self.change = uiModel.changePercentage
        self.rank = uiModel.rank
        self.sparkline = uiModel.sparkline
        self.listedAt = Int(DateFormatter().date(from: uiModel.listedAt)?.timeIntervalSince1970 ?? 0)
        self.tier = Int(uiModel.tier.components(separatedBy: " ").last ?? "1") ?? 1 // Extract tier as an integer
        self.lowVolume = uiModel.lowVolume
        self.coinrankingUrl = uiModel.coinRankingURL?.absoluteString ?? ""
        self.btcPrice = uiModel.btcPrice
        self.contractAddresses = uiModel.contractAddresses
        self.isFavorite = uiModel.isFavorite
    }
}

extension CoinDomainModel {
    init(
        uuid: String,
        symbol: String,
        name: String,
        color: String?,
        iconUrl: String,
        marketCap: String,
        price: String,
        t24hVolume: String,
        change: String,
        rank: Int,
        sparkline: [String],
        listedAt: Int,
        tier: Int,
        lowVolume: Bool,
        coinrankingUrl: String,
        btcPrice: String,
        contractAddresses: [String],
        isFavorite: Bool = false
    ) {
        self.uuid = uuid
        self.symbol = symbol
        self.name = name
        self.color = color
        self.iconUrl = iconUrl
        self.marketCap = marketCap
        self.price = price
        self.t24hVolume = t24hVolume
        self.change = change
        self.rank = rank
        self.sparkline = sparkline
        self.listedAt = listedAt
        self.tier = tier
        self.lowVolume = lowVolume
        self.coinrankingUrl = coinrankingUrl
        self.btcPrice = btcPrice
        self.contractAddresses = contractAddresses
        self.isFavorite = isFavorite
    }    
}
