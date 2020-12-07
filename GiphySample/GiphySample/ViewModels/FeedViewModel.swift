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
    // When the complexity of the app grows we shall separate the 'search' functionality.
    struct Input {
        let favouriteTapped: Observable<String>
        let searchTextDriver: Driver<String>
    }

    struct Output {
        let trendingGifsDriver: Driver<[GifTVCellViewModel]>
        let searchedGifsDriver: Driver<[GifTVCellViewModel]>
        let isFetchingTrendingGifsDriver: Driver<Bool>
        let isSearchingGifsDriver: Driver<Bool>
    }
    
    // MARK: ICons
    let title: String
    
    // MARK: Private ICons
    private let _interactor: FeedViewInteractor
    private let _disposeBag = DisposeBag()
    
    init(interactor: FeedViewInteractor, title: String) {
        self._interactor = interactor
        self.title = title
    }
    
    func loadTrendingGifs() {
        _interactor.fetchTrendingGifs(offset: Int32(_interactor.trendingGifs.value.count))
    }
    
    func loadSearchedGifs() {
        let searchText = _interactor.searchTextRelay.value
        guard !searchText.isEmpty else { return }
        _interactor.fetchGifsMatching(query: searchText, offset: Int32(_interactor.searchedGifs.value.count))
    }
    
    func connect(_ input: Input) -> Output {
        let dataDriver = _interactor.trendingGifs.map {
            $0.map { GifTVCellViewModel(model: $0) }
        }
        .asDriver(onErrorJustReturn: [])
        
        let searchedDataDriver = _interactor.searchedGifs.map {
            $0.map { GifTVCellViewModel(model: $0) }
        }
        .asDriver(onErrorJustReturn: [])
        
        _ = input.favouriteTapped.bind(to: _interactor.favouriteToggle)
        // Don't need to put in dispose bag because the button will emit a `completed` event when done.
        // All UIControls will emit a completed event when they are dealloced.
        
        input.searchTextDriver
            .asObservable()
            .bind(to: _interactor.searchTextRelay)
            .disposed(by: _disposeBag)

        let isFetchingTrendingGifsDriver = _interactor.isFetchingTrendingGifs.asDriver(onErrorJustReturn: false)
        let isSearchingGifsDriver = _interactor.isSearchingGifs.asDriver(onErrorJustReturn: false)
        
        return Output(trendingGifsDriver: dataDriver, searchedGifsDriver: searchedDataDriver, isFetchingTrendingGifsDriver: isFetchingTrendingGifsDriver, isSearchingGifsDriver: isSearchingGifsDriver)
    }
}
