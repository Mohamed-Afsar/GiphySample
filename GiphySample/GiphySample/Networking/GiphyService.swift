//
//  GiphyService.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxSwift

final class GiphyService: GiphyServiceProtocol {
    // MARK: Private ICons
    private let _environment = HTTPEnvironment.production
    private let _httpClient = HTTPClient()
    
    // MARK: Functions
    func getTrendingGifs(offset: Int32) -> Observable<TrendingModel> {
        let request = GifsEndpoint.trending(apiKey: _environment.apiKey, offset: offset)
        return _httpClient.execute(request: request, environment: _environment)
    }
    
    func getGifsMatching(query: String, offset: Int32) -> Observable<SearchModel> {
        let request = GifsEndpoint.search(apiKey: _environment.apiKey, query: query, offset: offset)
        return _httpClient.execute(request: request, environment: _environment)
    }
}

