//
//  GifsEndpoint.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

enum GifsEndpoint {
    case trending(apiKey: String, offset: Int32)
    case search(apiKey: String, query: String, offset: Int32)
}

extension GifsEndpoint: HTTPRequestProtocol {
    var path: String {
        switch self {
        case .trending:
            return "v1/gifs/trending" // NO I18N
        case .search:
            return "v1/gifs/search" // NO I18N
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .trending, .search:
            return .get
        }
    }
    
    var parameters: HTTPRequestParameters? {
        switch self {
        case .trending(let apiKey, let offset):
            return ["api_key": apiKey, "limit": 20, "offset": offset, "rating": "g"] // NO I18N
        case .search(let apiKey, let query, let offset):
            return ["api_key": apiKey, "q": query, "limit": 20, "offset": offset, "rating": "g"] // NO I18N
        }
    }
    
    var headers: HTTPRequestHeaders? {
        switch self {
        case .trending, .search:
            return nil
        }
    }
}
