// Result+NetworkService.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension Result where Success == (Data, URLResponse), Failure == any Error {
    /// Casts and unwraps a `URLSession.DataTaskPublisher.Output` while ensuring the
    /// response code indicates success.
    /// - Returns:
    ///     - `Publishers.TryMap<Self, Data>`
    public func httpMap() -> Result<Data, NetworkService.Failure> {
        flatMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkService.Failure.urlResponse(response))
            }
            guard httpResponse.isSuccessful else {
                return .failure(NetworkService.Failure.httpResponse(httpResponse))
            }
            return .success(data)
        }
        .mapToNetworkError()
    }
}

extension Result {
    /// Convenience method for mapping errors to `NetworkService.Failure`
    /// - Returns:
    ///     - `Publishers.MapError<Self, NetworkService.Failure>`
    public func mapToNetworkError() -> Result<Success, NetworkService.Failure> {
        mapError { error in
            if let urlError = error as? URLError {
                return .urlError(urlError)
            } else if let failure = error as? NetworkService.Failure {
                return failure
            } else {
                return .unknown(error as NSError)
            }
        }
    }
}

#if canImport(Combine)
    import Combine

    extension Result {
        func decode<T: Decodable, Decoder: TopLevelDecoder>(with decoder: Decoder) -> Result<T, any Error>
            where Decoder.Input == Success
        {
            mapError { $0 as any Error }
                .flatMap { input in
                    Result<T, any Error> {
                        try decoder.decode(T.self, from: input)
                    }
                }
        }

        func decode<T: TopLevelDecodable>() -> Result<T, any Error> where T.AdoptedDecoder.Input == Success {
            decode(with: T.decoder)
        }
    }
#endif
