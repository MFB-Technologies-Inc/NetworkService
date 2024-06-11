// NetworkServiceClient+Start.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension NetworkServiceClient {
    /// Start a `HTTPRequest`
    /// - Parameter request: The request as a `HTTPRequest`
    /// - Returns: `Result` with output as `Data` and `NetworkService`'s error domain for failure
    @Sendable
    @inlinable
    public static func defaultStart(_ request: HTTPRequest, body: Data?, session: URLSession) async -> Result<Data, Failure> {
        let result: Result<(Data, HTTPResponse), any Error>
        do {
            let response: (Data, HTTPResponse) = try await response(request, body: body, session: session)

            result = .success(response)
        } catch {
            result = .failure(error)
        }
        return result
            .httpMap()
            .mapToNetworkError()
    }

    /// Starting the `HTTPRequest` directly via the `HTTPTypesFoundation` API is breaking tests in unexpected ways.
    /// Sticking with this implementation for now until it can be sorted out.
    @usableFromInline
    static func response(_ request: HTTPRequest, body: Data?, session: URLSession) async throws -> (Data, HTTPResponse) {
        let dataTaskBox = DataTaskBox()
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { [session] continuation in
                    guard var urlRequest = URLRequest(httpRequest: request) else {
                        continuation.resume(throwing: NetworkServiceError.invalidRequest(request))
                        return
                    }
                    urlRequest.httpBody = body
                    let task = session.dataTask(
                        with: urlRequest,
                        completionHandler: { data, urlResponse, error in
                            guard let data, let urlResponse,
                                  let httpUrlResponse = urlResponse as? HTTPURLResponse,
                                  let httpResponse = httpUrlResponse.httpResponse
                            else {
                                return continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            }
                            continuation.resume(returning: (data, httpResponse))
                        }
                    )

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
        /// Start a `HTTPRequest`
        /// - Parameter request: The request as a `HTTPRequest`
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        public func start<ResponseBody, Decoder>(
            _ request: HTTPRequest,
            body: Data?,
            with decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            await start(request, body: body)
                .decode(with: decoder)
                .mapToNetworkError()
        }

        /// Start a `HTTPRequest`
        /// - Parameter request: The request as a `HTTPRequest`
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        public func start<ResponseBody>(_ request: HTTPRequest, body: Data?) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await start(request, body: body, with: ResponseBody.decoder)
        }

        /// Start a `HTTPRequest`
        /// - Parameter request: The request as a `HTTPRequest`
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func start<Encoder, ResponseBody, Decoder>(
            _ request: HTTPRequest,
            body: (some Encodable)?,
            encoder: Encoder,
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where Encoder: TopLevelEncoder, Encoder.Output == Data, ResponseBody: Decodable,
            Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            do {
                let encodedBody: Data? = try encoder.encode(body)
                return await start(request, body: encodedBody)
                    .decode(with: decoder)
                    .mapToNetworkError()
            } catch {
                return Result<ResponseBody, any Error>.failure(error)
                    .mapToNetworkError()
            }
        }

        /// Start a `HTTPRequest`
        /// - Parameter request: The request as a `HTTPRequest`
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func start<RequestBody, ResponseBody>(_ request: HTTPRequest,
                                                     body: RequestBody?) async -> Result<ResponseBody, Failure>
            where RequestBody: TopLevelEncodable, ResponseBody: TopLevelDecodable
        {
            await start(request, body: body, encoder: RequestBody.encoder, decoder: ResponseBody.decoder)
        }
    }
#endif
