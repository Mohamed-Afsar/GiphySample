//
//  SearchModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 06/12/20.
//

import Foundation

struct SearchModel: Decodable, CustomStringConvertible {
    let data: [GifModel]
    
    var description: String {
        """
        data: \(data)
        """
    }
}
