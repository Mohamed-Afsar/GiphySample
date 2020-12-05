//
//  GifImagesModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

struct GifImagesModel: Decodable {
    let fixed_height: FixedHeight
    let fixed_width: FixedWidth
    
    var preferredMeta: GifImageMeta {
        guard let width = Int32(self.fixed_height.width), let height = Int32(self.fixed_height.height) else {
            return self.fixed_width
        }
        return width > height ? self.fixed_height : self.fixed_width
    }
    var width: Int32 { return Int32(self.preferredMeta.width) ?? 0 }
    var height: Int32 { return Int32(self.preferredMeta.height) ?? 0 }
}

extension GifImagesModel: CustomStringConvertible {
    var description: String {
        """
        fixed_height: \(fixed_height)
        fixed_width: \(fixed_width)
        """
    }
}

// MARK: Internal types
protocol GifImageMeta {
    var url: String { get }
    var width: String { get }
    var height: String { get }
}

extension GifImagesModel {
    struct FixedHeight: GifImageMeta, Decodable, CustomStringConvertible {
        let url: String
        let width: String
        let height: String
        
        var description: String {
            """
            url: \(url)
            width: \(width)
            height: \(height)
            """
        }
    }
    
    struct FixedWidth: GifImageMeta, Decodable, CustomStringConvertible {
        let url: String
        let width: String
        let height: String
        
        var description: String {
            """
            url: \(url)
            width: \(width)
            height: \(height)
            """
        }
    }
}
