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
    func fetchFavorites() -> [FavouriteCoinModel]
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
    
    func saveFavorite(_ coin: Coin) {
        let context = coreData.context
        guard let entity = NSEntityDescription.entity(forEntityName: favCoinEntity, in: context) else { return }
//        guard let uuid = UUID(uuidString: coin.uuid) else{
//            return
//        }
        let obj = NSManagedObject(entity: entity, insertInto: context)
        obj.setValue(coin.iconUrl, forKey: "image")
        obj.setValue(coin.price, forKey: "price")
        obj.setValue(coin.uuid, forKey: "uuid")
        obj.setValue(coin.name, forKey: "name")
        obj.setValue(coin.sparkline, forKey: "sparkline")
        
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
    
    func fetchFavorites() -> [FavouriteCoinModel] {
        let context = coreData.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: favCoinEntity)
        
        do {
            let results = try context.fetch(fetchRequest)
            return []
//            return results.compactMap { data in
//                guard let image = data.value(forKey: "image") as? String,
//                      let price = data.value(forKey: "price") as? String,
//                      let uuid = data.value(forKey: "uuid") as? String,
//                      let name = data.value(forKey: "name") as? String
//                else { return nil }
//                
//                let sparkline = data.value(forKey: "sparkline") as? [String] ?? []
//                return FavouriteCoinModel(image: image, price: price, uuid: uuid, name: name, sparkline: sparkline)
//            }
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
}
