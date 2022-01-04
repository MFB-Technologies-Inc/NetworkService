// Publisher+NetworkService.swift
// NetworkService
//
// Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation

extension Publisher where Output == URLSession.DataTaskPublisher.Output {
    /// Casts and unwraps a `URLSession.DataTaskPublisher.Output` while ensuring the
    /// response code indicates success.
    /// - Returns:
    ///     - `Publishers.TryMap<Self, Data>`
    public func tryHTTPMap() -> Publishers.TryMap<Self, Data> {
        tryMap { data, response -> Data in
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

extension Publisher {
    /// Convenience method for mapping errors to `NetworkService.Failure`
    /// - Returns:
    ///     - `Publishers.MapError<Self, NetworkService.Failure>`
    public func mapToNetworkError() -> Publishers.MapError<Self, NetworkService.Failure> {
        mapError { error -> NetworkService.Failure in
            guard let apiError = error as? NetworkService.Failure else {
                return NetworkService.Failure.cocoa(error as NSError)
            }
            return apiError
        }
    }
}

extension Publisher where Output == Data {
    func decode<T: Decodable, Decoder: TopLevelDecoder>(with decoder: Decoder) -> Publishers.Decode<Self, T, Decoder> {
        decode(type: T.self, decoder: decoder)
    }

    func decode<T: TopLevelDecodable>() -> Publishers.Decode<Self, T, T.Decoder> {
        decode(type: T.self, decoder: T.decoder)
    }
}
