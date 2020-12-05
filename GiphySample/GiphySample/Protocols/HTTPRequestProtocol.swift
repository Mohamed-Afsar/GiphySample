//
//  HTTPRequestProtocol.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

/// Type alias used for HTTP request parameters.
typealias HTTPRequestParameters = [String : Any?]

/// Type alias used for HTTP request headers.
internal typealias HTTPRequestHeaders = [String: String]

protocol HTTPRequestProtocol {
    /// The path that will be appended to API's base URL.
    var path: String { get }
    
    /// The HTTP method.
    var method: HTTPRequestMethod { get }

    /// The parameters used for query parameters.
    var parameters: HTTPRequestParameters? { get }
    
    /// The HTTP headers.
    var headers: HTTPRequestHeaders? { get }
}

/// HTTP request methods.
enum HTTPRequestMethod: String {
    case get = "GET" // NO I18N
    case post = "POST" // NO I18N
    case put = "PUT" // NO I18N
    case patch = "PATCH" // NO I18N
    case delete = "DELETE" // NO I18N
}
