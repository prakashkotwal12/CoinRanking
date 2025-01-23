//
//  CoreDataManager.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import CoreData
import UIKit
import Alamofire

// MARK: - CoreDataManager
final class CoreDataManager {
    static let shared = CoreDataManager()
    private let modelName: String = "CoinRanking"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save CoreData context: \(error)")
            }
        }
    }    
}
