//
//  GifsEndpoint.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

enum GifsEndpoint {
    case trending(apiKey: String, offset: Int32)
}

extension GifsEndpoint: HTTPRequestProtocol {
    var path: String {
        switch self {
        case .trending:
            return "v1/gifs/trending" // NO I18N
        }
    }
    
    var method: HTTPRequestMethod {
        switch self {
        case .trending:
            return .get
        }
    }
    
    var parameters: HTTPRequestParameters? {
        switch self {
        case .trending(let apiKey, let offset):
            return ["api_key": apiKey, "limit": 15, "offset": offset, "rating": "g"] // NO I18N
        }
    }
    
    var headers: HTTPRequestHeaders? {
        switch self {
        case .trending:
            return nil
        }
    }
}
