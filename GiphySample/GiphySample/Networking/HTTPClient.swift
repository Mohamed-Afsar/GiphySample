//
//  HTTPClient.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxSwift

final class HTTPClient: HTTPClientProtocol {
    // MARK: Functions
    func execute<T>(request: HTTPRequestProtocol, environment: HTTPEnvironmentProtocol) -> Observable<T> where T : Decodable {
        // By doing this way we have more control compared to 'URLSession.shared.rx'.
        return Observable.create { (observer) -> Disposable in
            guard let urlRequest = request.urlRequest(with: environment) else {
                observer.onError(ClientError.requestCreationFailed)
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    if let data = data {
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(decoded)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    }
                    else {
                        observer.onError(ClientError.invalidResponseData)
                    }
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

// MARK: Internal Types
extension HTTPClient {
    enum ClientError: Error {
        case requestCreationFailed
        case invalidResponseData
    }
}
