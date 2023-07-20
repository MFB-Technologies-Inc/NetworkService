// NetworkServiceClient+Start.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension NetworkServiceClient {
    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with output as `Data` and `NetworkService`'s error domain for failure
    public func start(_ request: URLRequest) async -> Result<Data, Failure> {
        let result: Result<(Data, URLResponse), Error>
        do {
            let response: (Data, URLResponse) = try await response(request)
            result = .success(response)
        } catch {
            result = .failure(error)
        }
        return result
            .httpMap()
    }

    private func response(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { [session = getSession()] continuation in
            let task = session.dataTask(with: request, completionHandler: { data, urlResponse, error in
                guard !Task.isCancelled else {
                    return continuation.resume(with: .failure(URLError(.cancelled)))
                }
                guard let data = data, let urlResponse = urlResponse else {
                    return continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
                continuation.resume(returning: (data, urlResponse))
            })
            task.resume()
        }
    }
}

private final class TaskIdBox {
    var value: Int?

    init(_ value: Int? = nil) {
        self.value = value
    }
}

#if canImport(Combine)
    import Combine
    extension NetworkServiceClient {
        /// Start a `URLRequest`
        /// - Parameter request: The request as a `URLRequest`
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func start<ResponseBody, Decoder>(
            _ request: URLRequest,
            with decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            await start(request)
                .decode(with: decoder)
                .mapToNetworkError()
        }

        /// Start a `URLRequest`
        /// - Parameter request: The request as a `URLRequest`
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func start<ResponseBody>(_ request: URLRequest) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await start(request, with: ResponseBody.decoder)
        }
    }
#endif
