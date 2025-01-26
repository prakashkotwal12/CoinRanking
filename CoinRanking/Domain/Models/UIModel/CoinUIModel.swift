//
//  CoinUIModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 26/01/2025.
//
import Foundation

struct CoinUIModel {
    let id: String
    let symbol: String
    let name: String
    let color: String?
    let iconURL: URL?
    let marketCap: String
    let price: String
    let volume24h: String
    let change : String
    let changePercentage: String
    let rank: Int
    let sparkline: [String]
    let listedAt: String
    let tier: String
    let lowVolume: Bool
    let coinRankingURL: URL?
    let btcPrice: String
    let contractAddresses: [String]
    let isFavorite: Bool
}

extension CoinUIModel {
    init(from domainModel: CoinDomainModel) {
        self.id = domainModel.uuid
        self.symbol = domainModel.symbol
        self.name = domainModel.name
        self.color = domainModel.color
        self.iconURL = URL(string: domainModel.iconUrl)
        self.marketCap = domainModel.marketCap
        self.price = domainModel.price
        self.volume24h = domainModel.t24hVolume
        self.change = domainModel.change
        self.changePercentage = domainModel.change
        self.rank = domainModel.rank
        self.sparkline = domainModel.sparkline.compactMap { $0 }
        self.listedAt = DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(domainModel.listedAt)),
                                                      dateStyle: .medium, timeStyle: .none)
        self.tier = "Tier \(domainModel.tier)" // Convert to a user-friendly string
        self.lowVolume = domainModel.lowVolume
        self.coinRankingURL = URL(string: domainModel.coinrankingUrl)
        self.btcPrice = domainModel.btcPrice
        self.contractAddresses = domainModel.contractAddresses
        self.isFavorite = domainModel.isFavorite
    }    
}
