//
//  HTTPEnvironment.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

enum HTTPEnvironment {
    case production
}

extension HTTPEnvironment: HTTPEnvironmentProtocol {
    var apiKey: String {
        switch self {
        case .production:
            return "WRUcSf5QAE58wsMZEels0jtzIhqLIJZO" // NO I18N
        }
    }
    
    var headers: HTTPRequestHeaders? {
        switch self {
        case .production:
            return nil
        }
    }
    
    var baseURL: String {
        switch self {
        case .production:
            return "https://api.giphy.com/" // NO I18N
        }
    }
}
