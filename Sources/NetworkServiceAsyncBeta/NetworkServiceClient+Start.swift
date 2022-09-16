// NetworkServiceClient+Start.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation

extension NetworkServiceClient {
    // MARK: URLRequest

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
            .mapToNetworkError()
    }

    private func response(_ request: URLRequest) async throws -> (Data, URLResponse) {
        let session = getSession()
        if #available(iOS 15, watchOS 8, macOS 12, macCatalyst 15, tvOS 15, *) {
            return try await session.data(for: request)
        } else {
            var task: URLSessionDataTask?
            var shouldCancel: Bool = false
            let onCancel = {
                if let task = task {
                    task.cancel()
                } else {
                    shouldCancel = true
                }
            }
            return try await withTaskCancellationHandler(
                handler: { onCancel() },
                operation: {
                    try await withCheckedThrowingContinuation { continuation in
                        task = session.dataTask(with: request, completionHandler: { _data, _urlResponse, _error in
                            guard let data = _data, let urlResponse = _urlResponse else {
                                return continuation.resume(throwing: _error ?? URLError(.badServerResponse))
                            }
                            continuation.resume(returning: (data, urlResponse))
                        })
                        
                        if shouldCancel {
                            task?.cancel()
                        } else {
                            task?.resume()
                        }
                    }
                }
            )
        }
    }
}
