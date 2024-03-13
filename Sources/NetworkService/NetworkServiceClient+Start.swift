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
    /// - Returns: Type erased publisher with output as `Data` and `NetworkService`'s error domain for failure
    public func start(_ request: HTTPRequest, body: Data?) async -> Result<Data, Failure> {
        let result: Result<(Data, HTTPResponse), Error>
        do {
            let response: (Data, HTTPResponse) = try await response(request, body: body)

            result = .success(response)
        } catch {
            result = .failure(error)
        }
        return result
            .httpMap()
            .mapToNetworkError()
    }

    private func response(_ request: HTTPRequest, body: Data?) async throws -> (Data, HTTPResponse) {
        let session = getSession()
        let taskIdBox = TaskIdBox()
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { [session] continuation in
                    var urlRequest = URLRequest(httpRequest: request)!
                    urlRequest.httpBody = body
                    let task = session.dataTask(
                        with: urlRequest,
                        completionHandler: { data, urlResponse, error in
                            guard let data = data, let urlResponse = urlResponse,
                                  let httpUrlResponse = urlResponse as? HTTPURLResponse,
                                  let httpResponse = httpUrlResponse.httpResponse
                            else {
                                return continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            }
                            continuation.resume(returning: (data, httpResponse))
                        }
                    )
                    taskIdBox.value = task.taskIdentifier

                    task.resume()
                }
            },
            onCancel: { [session, taskIdBox] in
                guard let taskId = taskIdBox.value else {
                    return
                }
                session.getAllTasks(completionHandler: { allTasks in
                    if let task = allTasks.first(where: { $0.taskIdentifier == taskId }) {
                        task.cancel()
                    }
                })
            }
        )
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
        /// Start a `HTTPRequest`
        /// - Parameter request: The request as a `HTTPRequest`
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
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
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func start<ResponseBody>(_ request: HTTPRequest, body: Data?) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await start(request, body: body, with: ResponseBody.decoder)
        }

        /// Start a `HTTPRequest`
        /// - Parameter request: The request as a `HTTPRequest`
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func start<RequestBody, Encoder, ResponseBody, Decoder>(
            _ request: HTTPRequest,
            body: RequestBody?,
            encoder: Encoder,
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where RequestBody: Encodable, Encoder: TopLevelEncoder, Encoder.Output == Data, ResponseBody: Decodable,
            Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            do {
                let encodedBody: Data? = try encoder.encode(body)
                return await start(request, body: encodedBody)
                    .decode(with: decoder)
                    .mapToNetworkError()
            } catch {
                return Result<ResponseBody, Error>.failure(error)
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
