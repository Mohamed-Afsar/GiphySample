//
//  FeedViewInteractor.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 06/12/20.
//

import Foundation
import RxSwift
import RxRelay

final class FeedViewInteractor {
    // MARK: IVars
    let trendingGifs = BehaviorRelay<[GifModel]>(value: [])
    let favouriteToggle = PublishRelay<String>()
    
    // MARK: Private ICons
    private let _giphyService = GiphyService()
    private let _disposeBag = DisposeBag()
    
    // MARK: Functions
    init() {
        #warning("TODO: Test this binding")
        self.favouriteToggle.bind { (identifier) in
            print("makeFavourite.bind: \(identifier)")
        }.disposed(by: _disposeBag)
    }
    
    func fetchTrendingGifs(offset: Int32) {
        _giphyService.getTrendingGifs(offset: offset).map { $0.data }.bind { [weak self] in
            self?.trendingGifs.accept((self?.trendingGifs.value ?? []) + $0)
        }
        .disposed(by: _disposeBag)
    }
}
