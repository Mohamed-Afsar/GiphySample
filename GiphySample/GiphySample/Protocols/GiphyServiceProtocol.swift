//
//  GiphyServiceProtocol.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxSwift

protocol GiphyServiceProtocol {
    func getTrendingGifs(offset: Int32) -> Observable<TrendingModel>
    func getGifsMatching(query: String, offset: Int32) -> Observable<SearchModel>
}
