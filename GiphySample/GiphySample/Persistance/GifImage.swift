//
//  GifImage.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import Foundation

struct GifImage: PersistableImage {
    let id: String
    let data: Data
    let width: Int32
    let height: Int32
}
