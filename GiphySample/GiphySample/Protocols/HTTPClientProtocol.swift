//
//  HTTPClientProtocol.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 05/12/20.
//

import Foundation
import RxSwift

protocol HTTPClientProtocol {
    func execute<T: Decodable>(request: HTTPRequestProtocol, environment: HTTPEnvironmentProtocol) -> Observable<T>
}
