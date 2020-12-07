//
//  FavouritesViewModel.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import Foundation
import RxCocoa
import RxSwift

final class FavouritesViewModel {
    struct Input {
        typealias FavouriteState = (isFavourite: Bool, image: PersistableImage)
        let favouriteTapped: Observable<FavouriteState>
    }

    struct Output {
        let favouriteGifsRelay: BehaviorRelay<[GifCnVwCellViewModel]>
    }
    
    // MARK: ICons
    let title: String
    
    // MARK: Private ICons
    private let _cellModelsRelay = BehaviorRelay<[GifCnVwCellViewModel]>(value: [])
    private let _interactor: FavouritesViewInteractor
    private let _disposeBag = DisposeBag()
    private let _favouriteGifsProvider = PersistedGifDataProvider()
    
    // MARK: Private IVars
    init(interactor: FavouritesViewInteractor, title: String) {
        _interactor = interactor
        self.title = title
    }
    
    func connect(_ input: Input) -> Output {
        _favouriteGifsProvider.persistedGifs.map {
                        
            $0.map { GifCnVwCellViewModel(model: $0) }
        }
        .bind(to: _cellModelsRelay)
        .disposed(by: _disposeBag)        

        _favouriteGifsProvider.start()
        
        _ = input.favouriteTapped.bind(to: _interactor.favouriteToggle)
        // Don't need to put in dispose bag because the button will emit a `completed` event when done.
        // All UIControls will emit a completed event when they are dealloced.
                
        return Output(favouriteGifsRelay: _cellModelsRelay)
    }
}
