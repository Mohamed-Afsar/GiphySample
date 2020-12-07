//
//  PersistanceManager.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import Foundation
import CoreData

final class PersistanceManager: PersistanceManageable {
    
    // MARK: Private Static ICons
    private static let kGifDirName = "FavouriteGifs" // NO I18N
    
    // MARK: ICons
    private let _gifEntity: NSEntityDescription = {
        let name = CoreDataManager.Entity.PersistedGif.rawValue
        return NSEntityDescription.entity(forEntityName: name, in: CoreDataManager.shared.defaultContext)!
    }()
    
    // MARK: IVars
    private lazy var _gifsDir: URL = {
        let gifsDirUrl = CoreDataManager.shared.documentsDirectory.appendingPathComponent(PersistanceManager.kGifDirName)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: gifsDirUrl.path) {
            do {
                try fileManager.createDirectory(atPath: gifsDirUrl.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory. Error: \(error)") // NO I18N
            }
        }
        return gifsDirUrl
    }()
    
    // MARK: Functions
    func save(image: PersistableImage) {
        let pGif: PersistedGif
        if let gif = _fetchGif(id: image.id) {
            pGif = gif
        }
        else {
            pGif = PersistedGif(entity: _gifEntity, insertInto: CoreDataManager.shared.defaultContext)
        }
        _update(gif: pGif, data: image)
    }
    
    func removeImage(id: String) {
        let gifUrl = _imageUrl(id: id, dir: _gifsDir)
        try? FileManager.default.removeItem(at: gifUrl)
        if let gif = _fetchGif(id: id) {
            CoreDataManager.shared.defaultContext.delete(gif)
            CoreDataManager.shared.saveContext()
        }
    }
}

// MARK: Helper Functions
private extension PersistanceManager {
    func _fetchGif(id: String) -> PersistedGif? {
        let fReq = NSFetchRequest<PersistedGif>()
        fReq.entity = self._gifEntity
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = NSPredicate(format: "id == %@", id)
        let results = try? CoreDataManager.shared.defaultContext.fetch(fReq)
        return results?.first
    }
    
    func _update(gif: PersistedGif, data: PersistableImage) {
        let _ = _updateGifImage(id: data.id, data: data.data, dir: _gifsDir)
        gif.id = data.id
        gif.height = data.height
        gif.width = data.width
        gif.relativeDocDirPath = _relativeImageDocDirPath(id: data.id)
        gif.time = Date().timeIntervalSince1970
        CoreDataManager.shared.saveContext()
    }
    
    func _updateGifImage(id: String, data: Data, dir: URL) -> URL {
        let gifUrl = _imageUrl(id: id, dir: dir)
        try? FileManager.default.removeItem(at: gifUrl)
        do {
            try data.write(to: gifUrl)
        }
        catch {
            print("Error while saving the gif file: \(error)")
        }
        return gifUrl
    }
    
    func _imageUrl(id: String, dir: URL) -> URL {
        return dir.appendingPathComponent("\(id).gif") // NO I18N
    }
    
    func _relativeImageDocDirPath(id: String) -> String {
        return "\(PersistanceManager.kGifDirName)/\(id).gif" // NO I18N
    }
}
