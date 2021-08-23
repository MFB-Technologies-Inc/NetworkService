//
//  Publisher+NetworkService.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import Combine

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    /// Casts and unwraps a `URLSession.DataTaskPublisher.Output` while ensuring the
    /// response code indicates success.
    /// - Returns:
    ///     - `Publishers.TryMap<Self, Data>`
    public func tryHTTPMap() -> Publishers.TryMap<Self, Data> {
        self.tryMap { data, response -> Data in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkService.Failure.url(response)
            }
            guard httpResponse.isSuccessful else {
                throw NetworkService.Failure.http(httpResponse)
            }
            return data
        }
    }
}

extension Publisher where Failure: Error {
    /// Convenience method for mapping errors to `NetworkService.Failure`
    /// - Returns:
    ///     - `Publishers.MapError<Self, NetworkService.Failure>`
    public func mapToNetworkError() -> Publishers.MapError<Self, NetworkService.Failure> {
        self.mapError { error -> NetworkService.Failure in
            guard let apiError = error as? NetworkService.Failure else {
                return NetworkService.Failure.cocoa(error as NSError)
            }
            return apiError
        }
    }
}

extension Publisher where Output == Data {
    func decode<T: Decodable, Decoder: TopLevelDecoder>(with decoder: Decoder) -> Publishers.Decode<Self, T, Decoder> {
        self.decode(type: T.self, decoder: decoder)
    }

    func decode<T: CustomDecodable>() -> Publishers.Decode<Self, T, T.CustomDecoder> {
        self.decode(type: T.self, decoder: T.decoder)
    }
}
