//
//  MockCoreDataManager.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
import CoreData
@testable import CoinRanking

final class MockCoreDataManager: CoreDataManagerProtocol {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "CoinRanking")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory persistent store: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }    
}
