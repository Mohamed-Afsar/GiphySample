//
//  TrendingModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

struct TrendingModel: Decodable, CustomStringConvertible {
    let data: [GifModel]
    let pagination: PaginationModel
    
    var description: String {
        """
        data: \(data)
        pagination: \(pagination)
        """
    }
}
