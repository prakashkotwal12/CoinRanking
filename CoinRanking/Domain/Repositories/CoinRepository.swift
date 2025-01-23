//
//  CoinRepository.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import CoreData

protocol CoinRepositoryProtocol {
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<[Coin], Error>) -> Void)
    func saveFavorite(_ coin: Coin)
    func removeFavorite(uuid: String)
    func fetchFavorites() -> [FavCoins]
    func isFavorite(uuid: String) -> Bool
}

final class CoinRepository: CoinRepositoryProtocol {
    private let network: NetworkManagerProtocol
    private let coreData = CoreDataManager.shared
    
    init(network: NetworkManagerProtocol = NetworkManager.shared) {
        self.network = network
    }
    
    func fetchCoins(limit: Int, offset: Int, completion: @escaping (Result<[Coin], Error>) -> Void) {
        network.fetchCoins(limit: limit, offset: offset, completion: completion)
    }
    
    func saveFavorite(_ coin: Coin) {
        let context = coreData.context()
        let entity = NSEntityDescription.entity(forEntityName: "Coins", in: context)!
        let obj = NSManagedObject(entity: entity, insertInto: context)
        obj.setValue(coin.iconUrl, forKey: "image")
        obj.setValue(coin.price,   forKey: "price")
        obj.setValue(coin.uuid,    forKey: "uuid")
        obj.setValue(coin.name,    forKey: "name")
        obj.setValue(coin.sparkline, forKey: "sparkline")
        coreData.saveContext()
    }
    
    func removeFavorite(uuid: String) {
        let context = coreData.context()
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Coins")
        fetch.predicate = NSPredicate(format: "uuid == %@", uuid)
        if let results = try? context.fetch(fetch) {
            for obj in results { context.delete(obj) }
            coreData.saveContext()
        }
    }
    
    func fetchFavorites() -> [FavCoins] {
        let context = coreData.context()
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Coins")
        do {
            let results = try context.fetch(fetch)
            return results.compactMap { data in
                guard let image = data.value(forKey: "image") as? String,
                      let price = data.value(forKey: "price") as? String,
                      let uuid  = data.value(forKey: "uuid") as? String,
                      let name  = data.value(forKey: "name") as? String,
                      let spark = data.value(forKey: "sparkline") as? [String?] else { return nil }
                return FavCoins(image: image, price: price, uuid: uuid, name: name, sparkline: spark)
            }
        } catch { return [] }
    }
    
    func isFavorite(uuid: String) -> Bool {
        let context = coreData.context()
        let fetch = NSFetchRequest<NSManagedObject>(entityName: "Coins")
        fetch.predicate = NSPredicate(format: "uuid == %@", uuid)
        let count = (try? context.count(for: fetch)) ?? 0
        return count > 0
    }
}
