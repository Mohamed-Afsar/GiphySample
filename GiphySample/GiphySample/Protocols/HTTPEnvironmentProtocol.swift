//
//  HTTPEnvironmentProtocol.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

protocol HTTPEnvironmentProtocol {
    /// The key to access the environment.
    var apiKey: String { get }
    
    /// The default HTTP request headers for the environment.
    var headers: HTTPRequestHeaders? { get }

    /// The base URL of the environment.
    var baseURL: String { get }
}
