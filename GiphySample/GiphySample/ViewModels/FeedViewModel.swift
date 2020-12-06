//
//  FeedViewModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxSwift
import RxCocoa

final class FeedViewModel {
    // MARK: Internal Types
    struct Input {
        let favouriteTapped: Observable<String>
    }

    struct Output {
        let trendingGifsDriver: Driver<[GifTVCellViewModel]>
    }
    
    // MARK: Private ICons
    let interactor: FeedViewInteractor
    
    init(interactor: FeedViewInteractor) {
        self.interactor = interactor
    }
    
    func loadTrendingGifs() {
        interactor.fetchTrendingGifs(offset: 0)
    }
    
    func connect(_ input: Input) -> Output {
        let dataDriver = interactor.trendingGifs.map {
            $0.map { GifTVCellViewModel(model: $0) }
        }
        .asDriver(onErrorJustReturn: [])
        
        _ = input.favouriteTapped.bind(to: interactor.favouriteToggle)
        // Don't need to put in dispose bag because the button will emit a `completed` event when done.
        // All UIControls will emit a completed event when they are dealloced.
        
        return Output(trendingGifsDriver: dataDriver)
    }
}
