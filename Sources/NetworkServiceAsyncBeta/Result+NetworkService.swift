// Result+NetworkService.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension Result where Success == (Data, URLResponse), Failure == Error {
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
        .mapError { error in
            guard let failure = error as? NetworkService.Failure else {
                return .unknown(error as NSError)
            }
            return failure
        }
    }
}

extension Result {
    /// Convenience method for mapping errors to `NetworkService.Failure`
    /// - Returns:
    ///     - `Publishers.MapError<Self, NetworkService.Failure>`
    public func mapToNetworkError() -> Result<Success, NetworkService.Failure> {
        mapError { error in
            guard let failure = error as? NetworkService.Failure else {
                return NetworkService.Failure.unknown(error as NSError)
            }
            return failure
        }
    }
}

#if canImport(Combine)
    import Combine

    extension Result {
        func decode<T: Decodable, Decoder: TopLevelDecoder>(with decoder: Decoder) -> Result<T, Error>
            where Decoder.Input == Success
        {
            mapError { $0 as Error }
                .flatMap { input in
                    Result<T, Error> {
                        try decoder.decode(T.self, from: input)
                    }
                }
        }

        func decode<T: TopLevelDecodable>() -> Result<T, Error> where T.AdoptedDecoder.Input == Success {
            decode(with: T.decoder)
        }
    }
#endif
