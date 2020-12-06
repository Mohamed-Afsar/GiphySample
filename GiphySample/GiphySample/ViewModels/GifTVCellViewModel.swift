//
//  GifTVCellViewModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxRelay
import GiphyUISDK

final class GifTVCellViewModel {
    // MARK: ICons
    let title: String
    let imageMeta: GifImageMeta
    
    // MARK: IVars
    let gifImage = BehaviorRelay<GiphyYYImage?>(value: nil)
    
    // MARK: Private IVars
    private var _assetTask: URLSessionTask?
    
    init(model: GifModel) {
        self.title = model.title
        self.imageMeta = model.images.preferredMeta
        
        _assetTask = GPHCache.shared.downloadAsset(self.imageMeta.url) { [weak self] in
            self?.gifImage.accept($0)
            if let error = $1 {
                print("GifTVCellViewModel: downloadAsset: error: \(error)")
            }
        }
    }
    
    func ceaseAssetTask() {
        _assetTask?.cancel()
        _assetTask = nil
    }
}
