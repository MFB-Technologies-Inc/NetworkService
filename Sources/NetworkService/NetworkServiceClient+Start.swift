// NetworkServiceClient+Start.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension NetworkServiceClient {
    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: `Result` with output as `Data` and `NetworkService`'s error domain for failure
    public func start(_ request: URLRequest) async -> Result<Data, Failure> {
        let result: Result<(Data, URLResponse), any Error>
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
        let session = getSession()
        let dataTaskBox = DataTaskBox()
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { [session] continuation in
                    let task = session.dataTask(with: request, completionHandler: { data, urlResponse, error in
                        guard let data = data, let urlResponse = urlResponse else {
                            return continuation.resume(throwing: error ?? URLError(.badServerResponse))
                        }
                        continuation.resume(returning: (data, urlResponse))
                    })

                    if Task.isCancelled {
                        task.cancel()
                        return
                    }

                    dataTaskBox.task = task

                    task.resume()
                }
            },
            onCancel: { [dataTaskBox] in
                guard let task = dataTaskBox.task else {
                    return
                }
                task.cancel()
            }
        )
    }
}

/// While not truly `Sendable`, this type has a very narrow use that should always be safe.
/// It can be mutated in two places and there isn't a data race risk with either.
///
/// The `task` property may be set in the `withCheckedThrowingContinuation` of the `withTaskCancellation`'s `operation`
/// closure.
/// Therefore it may be set only once.
///
/// The `task` property may be accessed in the `withTaskCancellation`'s  `onCancel` closure. If `task` is `nil` when
/// accessed, there is no
/// side effect.
///
/// If the `withTaskCancellation`'s  `onCancel` closure is called before `task` is set, the `URLSessionDataTask` would
/// still get cancelled
/// when `Task.isCancelled` is checked before trying to resume it.
private final class DataTaskBox: @unchecked Sendable {
    var task: URLSessionDataTask?

    init(_ task: URLSessionDataTask? = nil) {
        self.task = task
    }
}

#if canImport(Combine)
    import Combine

    extension NetworkServiceClient {
        /// Start a `URLRequest`
        /// - Parameter request: The request as a `URLRequest`
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
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
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        public func start<ResponseBody>(_ request: URLRequest) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await start(request, with: ResponseBody.decoder)
        }
    }
#endif
