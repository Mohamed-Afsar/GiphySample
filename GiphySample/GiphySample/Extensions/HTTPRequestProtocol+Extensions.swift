//
//  HTTPRequestProtocol+Extensions.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation

extension HTTPRequestProtocol {
    /// Creates a URLRequest from this instance.
    func urlRequest(with environment: HTTPEnvironmentProtocol) -> URLRequest? {
        // Create the base URL.
        guard let url = self.url(with: environment.baseURL) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.httpBody = self.jsonBody
        return request
    }

    /// Creates a URL with the given base URL.
    private func url(with baseURL: String) -> URL? {
        // Create a URLComponents instance to compose the url.
        guard var urlComponents = URLComponents(string: baseURL) else {
            return nil
        }
        // Add the request path to the existing base URL path
        urlComponents.path = urlComponents.path + self.path
        // Add query items to the request URL
        urlComponents.queryItems = self.queryItems
        return urlComponents.url
    }

    /// Returns the URLRequest `URLQueryItem`
    private var queryItems: [URLQueryItem]? {
        // Chek if it is a GET method.
        guard self.method == .get, let parameters = self.parameters else {
            return nil
        }
        return parameters.map { (key: String, value: Any?) -> URLQueryItem in
            let valueString: String
            if let value = value {
                valueString = String(describing: value)
            }
            else {
                valueString = String(describing: value)
            }
            return URLQueryItem(name: key, value: valueString)
        }
    }

    /// Returns the URLRequest body `Data`
    private var jsonBody: Data? {
        // The body data should be used for POST, PUT and PATCH only
        guard [.post, .put, .patch].contains(self.method), let parameters = self.parameters else {
            return nil
        }
        
        var jsonBody: Data?
        do {
            jsonBody = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return jsonBody
    }
}
