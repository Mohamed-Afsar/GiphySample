//
//  GifModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

struct GifModel: Decodable, CustomStringConvertible {
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
