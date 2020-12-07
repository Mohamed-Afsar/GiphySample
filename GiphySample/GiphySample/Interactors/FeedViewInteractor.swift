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
    // MARK: ICons
    // When the complexity of the app grows we shall separate the 'search' functionality.
    let isFetchingTrendingGifs = BehaviorRelay<Bool>(value: false)
    let trendingGifs = BehaviorRelay<[GifModel]>(value: [])
    let isSearchingGifs = BehaviorRelay<Bool>(value: false)
    let searchedGifs = BehaviorRelay<[GifModel]>(value: [])
    let favouriteToggle = PublishRelay<String>()
    let searchTextRelay = BehaviorRelay<String>(value: "")
    
    // MARK: Private ICons
    private let _giphyService = GiphyService()
    private let _disposeBag = DisposeBag()
    
    // MARK: Functions
    init() {
        _bindRelayedData()
    }
    
    func fetchTrendingGifs(offset: Int32) {
        guard !isFetchingTrendingGifs.value else {
            return
        }
        isFetchingTrendingGifs.accept(true)
        _giphyService.getTrendingGifs(offset: offset)
            .map { $0.data }
            .bind { [weak self] in
                self?.trendingGifs.accept((self?.trendingGifs.value ?? []) + $0)
                self?.isFetchingTrendingGifs.accept(false)
            }
            .disposed(by: _disposeBag)
    }
    
    func fetchGifsMatching(query: String, offset: Int32) {
        guard !isSearchingGifs.value else {
            return
        }
        isSearchingGifs.accept(true)
        _giphyService.getGifsMatching(query: query, offset: offset)
            .map { $0.data }
            .bind { [weak self] in
                if offset > 0 {
                    self?.searchedGifs.accept((self?.searchedGifs.value ?? []) + $0)
                }
                else {
                    self?.searchedGifs.accept($0)
                }
                self?.isSearchingGifs.accept(false)
            }
            .disposed(by: _disposeBag)
    }
}

// MARK: Helper Functions
private extension FeedViewInteractor {
    func _bindRelayedData() {
        #warning("TODO: Test this binding")
        self.favouriteToggle.bind { (identifier) in
            print("makeFavourite.bind: \(identifier)")
        }
        .disposed(by: _disposeBag)

        self.searchTextRelay
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .skip(1)
            .bind(onNext: { [weak self] in
                guard !$0.isEmpty else { return }
                print("searchTextRelay: $0: \($0)")
                self?.fetchGifsMatching(query: $0, offset: 0)
            })
            .disposed(by: _disposeBag)
    }
}
