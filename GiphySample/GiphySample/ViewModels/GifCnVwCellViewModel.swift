//
//  GifCnVwCellViewModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxRelay
import GiphyUISDK

final class GifCnVwCellViewModel {
    // MARK: ICons
    let id: String
    let relativeDocDirImgPath: String
    let height: Int32
    let width: Int32
    
    init(model: PersistedGif) {
        self.id = model.id!
        self.relativeDocDirImgPath = model.relativeDocDirPath!
        self.height = model.height
        self.width = model.width
    }
}
