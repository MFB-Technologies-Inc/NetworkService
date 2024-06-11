// Result+NetworkService.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import HTTPTypes

extension Result where Success == (Data, HTTPResponse), Failure == any Error {
    /// Checks if the response status is successful and fails if not
    /// - Returns:
    ///     - `Result<Data, NetworkServiceError>`
    public func httpMap() -> Result<Data, NetworkServiceError> {
        flatMap { data, response in
            guard response.status.kind == .successful else {
                return .failure(NetworkServiceError.httpResponse(response))
            }
            return .success(data)
        }
        .mapToNetworkError()
    }
}

extension Result {
    /// Convenience method for mapping errors to `NetworkServiceError`
    /// - Returns:
    ///     - `Result<Success, NetworkServiceError>`
    public func mapToNetworkError() -> Result<Success, NetworkServiceError> {
        mapError { error in
            if let urlError = error as? URLError {
                .urlError(urlError)
            } else if let failure = error as? NetworkServiceError {
                failure
            } else {
                .unknown(error as NSError)
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
