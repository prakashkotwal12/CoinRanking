//
//  CoreDataManager.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteCoins")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func context() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do { try context.save() }
            catch { fatalError("Unresolved error \(error)") }
        }
    }    
}
