//
//  GifModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

// Hashable, Equatable - Adding capability to add this type in a 'Set'
struct GifModel: Decodable, CustomStringConvertible, Hashable, Equatable {
    let id: String
    let title: String
    let images: GifImagesModel
    
    var description: String {
        """
        id: \(id)
        title: \(title)
        images: \(images)
        """
    }
}
