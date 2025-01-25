//
//  CoinRepository.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import CoreData


protocol CoinRepositoryProtocol {
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinData, Error>) -> Void)
    func saveFavorite(_ coin: Coin)
    func removeFavorite(uuid: String)
    func fetchFavorites() -> [Coin]
    func isFavorite(uuid: String) -> Bool
}

// MARK: - CoinRepository
final class CoinRepository: CoinRepositoryProtocol {
    private let network: NetworkManagerProtocol
    private let coreData = CoreDataManager.shared
    private let favCoinEntity = "FavouritesCoins"
    
    init(network: NetworkManagerProtocol = NetworkManager.shared) {
        self.network = network
    }
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<CoinData, Error>) -> Void) {
        network.fetchCoins(limit: limit, offset: offset, completion: completion)
    }
    

    func isFavorite(uuid: String) -> Bool {
        let context = coreData.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favCoinEntity)
        
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            return try context.count(for: fetchRequest) > 0
        } catch {
            print("Error checking favorite status: \(error)")
            return false
        }
    }
    func fetchFavorites() -> [Coin] {
        let context = coreData.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favCoinEntity)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { data in
                guard let uuid = data.value(forKey: "uuid") as? String,
                      let symbol = data.value(forKey: "symbol") as? String,
                      let name = data.value(forKey: "name") as? String,
                      let color = data.value(forKey: "color") as? String,
                      let iconUrl = data.value(forKey: "iconUrl") as? String,
                      let marketCap = data.value(forKey: "marketCap") as? String,
                      let price = data.value(forKey: "price") as? String,
                      let t24hVolume = data.value(forKey: "t24hVolume") as? String,
                      let change = data.value(forKey: "change") as? String,
                      let rank = data.value(forKey: "rank") as? Int64,
                      let listedAt = data.value(forKey: "listedAt") as? Int64,
                      let tier = data.value(forKey: "tier") as? Int64,
                      let lowVolume = data.value(forKey: "lowVolume") as? Bool,
                      let coinrankingUrl = data.value(forKey: "coinrankingUrl") as? String,
                      let btcPrice = data.value(forKey: "btcPrice") as? String,
                      let sparkline = data.value(forKey: "sparkline") as? [String?],
                      let contractAddresses = data.value(forKey: "contractAddresses") as? [String]
                else { return nil }
                
                return Coin(
                    uuid: uuid,
                    symbol: symbol,
                    name: name,
                    color: color,
                    iconUrl: iconUrl,
                    marketCap: marketCap,
                    price: price,
                    t24hVolume: t24hVolume,
                    change: change,
                    rank: Int(rank),
                    sparkline: sparkline,
                    listedAt: Int(listedAt),
                    tier: Int(tier),
                    lowVolume: lowVolume,
                    coinrankingUrl: coinrankingUrl,
                    btcPrice: btcPrice,
                    contractAddresses: contractAddresses
                )
            }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }

    func saveFavorite(_ coin: Coin) {
        let context = coreData.context
        guard let entity = NSEntityDescription.entity(forEntityName: favCoinEntity, in: context) else { return }
        
        let obj = NSManagedObject(entity: entity, insertInto: context)
        obj.setValue(coin.uuid, forKey: "uuid")
        obj.setValue(coin.symbol, forKey: "symbol")
        obj.setValue(coin.name, forKey: "name")
        obj.setValue(coin.color, forKey: "color")
        obj.setValue(coin.iconUrl, forKey: "iconUrl")
        obj.setValue(coin.marketCap, forKey: "marketCap")
        obj.setValue(coin.price, forKey: "price")
        obj.setValue(coin.t24hVolume, forKey: "t24hVolume")
        obj.setValue(coin.change, forKey: "change")
        obj.setValue(Int64(coin.rank), forKey: "rank")
        obj.setValue(Int64(coin.listedAt), forKey: "listedAt")
        obj.setValue(Int64(coin.tier), forKey: "tier")
        obj.setValue(coin.lowVolume, forKey: "lowVolume")
        obj.setValue(coin.coinrankingUrl, forKey: "coinrankingUrl")
        obj.setValue(coin.btcPrice, forKey: "btcPrice")
        obj.setValue(coin.sparkline, forKey: "sparkline")
        obj.setValue(coin.contractAddresses, forKey: "contractAddresses")
        
        coreData.saveContext()
    }

    func removeFavorite(uuid: String) {
        let context = coreData.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favCoinEntity)
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            let results = try context.fetch(fetchRequest)
            results.forEach { context.delete($0) }
            coreData.saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
}
