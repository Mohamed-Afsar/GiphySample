//
//  CoreDataManager.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import CoreData

final class CoreDataManager {
    // MARK: Static Icons
    static let shared = CoreDataManager()
    
    // MARK: IVars
    lazy var documentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }()
    var defaultContext: NSManagedObjectContext { self.persistentContainer.viewContext }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GiphySample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Needs to be handled on demand.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        if defaultContext.hasChanges {
            do {
                try defaultContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: Internal Types
extension CoreDataManager {
    // Entities
    enum Entity: String {
        case PersistedGif
    }
}
