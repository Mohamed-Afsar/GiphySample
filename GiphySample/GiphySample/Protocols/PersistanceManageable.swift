//
//  PersistanceManageable.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import Foundation

protocol PersistanceManageable {
    func save(image: PersistableImage)
    func removeImage(id: String)
}
