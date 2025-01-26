//
//  CoreDataManager.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import UIKit
import Alamofire
import CoreData
import Foundation

protocol CoreDataManagerProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
}

final class CoreDataManager: CoreDataManagerProtocol {
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
        persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save CoreData context: \(error)")
        }
    }    
}
