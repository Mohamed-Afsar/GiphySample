//
//  FavouritesViewInteractor.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import UIKit
import RxSwift
import RxRelay

final class FavouritesViewInteractor {
    // MARK: ICons
    let favouriteToggle = PublishRelay<FavouritesViewModel.Input.FavouriteState>()
    
    // MARK: Private ICons
    private let _persistanceManager: PersistanceManageable = PersistanceManager()
    private let _disposeBag = DisposeBag()
    
    // MARK: Functions
    init() {
        _bindRelayedData()
    }
}

// MARK: Helper Functions
private extension FavouritesViewInteractor {
    func _bindRelayedData() {
        self.favouriteToggle.bind { [weak self] (isFavourite, gif) in
            guard let strongSelf = self else { return }
            if isFavourite {
                strongSelf._persistanceManager.save(image: gif)
            }
            else {
                strongSelf._persistanceManager.removeImage(id: gif.id)
            }
        }
        .disposed(by: _disposeBag)
    }
}
