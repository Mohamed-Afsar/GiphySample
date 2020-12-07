//
//  PersistableImage.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import Foundation

protocol PersistableImage {
    var id: String { get }
    var data: Data { get }
    var width: Int32 { get }
    var height: Int32 { get }
}
