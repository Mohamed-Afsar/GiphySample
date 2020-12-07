//
//  GifTVCellViewModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxSwift
import RxRelay
import GiphyUISDK

final class GifTVCellViewModel {
    // MARK: ICons
    let id: String
    let title: String
    let imageMeta: GifImageMeta
    
    // MARK: IVars
    let isFavourite = BehaviorRelay<Bool>(value: false)
    let gifImage = BehaviorRelay<GiphyYYImage?>(value: nil)
    let favouritesUpdate = BehaviorRelay<Set<String>>(value: [])
    
    // MARK: Private ICons
    private let _disposeBag = DisposeBag()
    
    // MARK: Private IVars
    private var _assetTask: URLSessionTask?
    
    init(model: GifModel) {
        self.id = model.id
        self.title = model.title
        self.imageMeta = model.images.preferredMeta
        
        _assetTask = GPHCache.shared.downloadAsset(self.imageMeta.url) { [weak self] in
            self?.gifImage.accept($0)
            if let error = $1 {
                print("GifTVCellViewModel: downloadAsset: error: \(error)")
            }
        }
        
        favouritesUpdate
            .map { $0.contains(model.id) }
            .bind(to: isFavourite)
            .disposed(by: _disposeBag)
    }
    
    func ceaseAssetTask() {
        _assetTask?.cancel()
        _assetTask = nil
    }
}
