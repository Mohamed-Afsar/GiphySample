//
//  PersistedGifDataProvider.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import UIKit
import CoreData
import RxRelay

final class PersistedGifDataProvider: NSObject {
    // MARK: ICons
    let persistedGifs = BehaviorRelay<[PersistedGif]>(value: [])
        
    // MARK: Private IVars
    private lazy var _favouritesFRC: NSFetchedResultsController<PersistedGif> = {
        let fetchReq = NSFetchRequest<PersistedGif>(entityName: CoreDataManager.Entity.PersistedGif.rawValue)
        let sortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        fetchReq.sortDescriptors = [sortDescriptor]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchReq,
            managedObjectContext: CoreDataManager.shared.defaultContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func start() {
        do {
            try self._favouritesFRC.performFetch()
            self.persistedGifs.accept(_favouritesFRC.fetchedObjects ?? [])
        }
        catch {
            print("favouritesFRC fetch error: \(error)")
        }
    }
}

extension PersistedGifDataProvider: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        persistedGifs.accept(_favouritesFRC.fetchedObjects ?? [])
    }
}
