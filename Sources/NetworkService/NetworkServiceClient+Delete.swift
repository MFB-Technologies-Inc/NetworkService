// NetworkServiceClient+Delete.swift
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
    // MARK: DELETE

    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: `Result` with `Data` output and `NetworkService`'s error domain for failure
    @inlinable
    public func delete(
        _ url: URL,
        headers: HTTPFields = HTTPFields()
    ) async -> Result<Data, Failure> {
        let request = HTTPRequest(method: .delete, url: url, headerFields: headers)
        return await start(request, body: nil)
    }
}

#if canImport(Combine)
    import Combine

    extension NetworkServiceClient {
        /// Send a delete request to a `URL`
        /// - Parameters:
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        ///   - decoder: `TopLevelDecoder` for decoding the response body
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        @Sendable
        @inlinable
        public func delete<ResponseBody, Decoder>(
            _ url: URL,
            headers: HTTPFields = HTTPFields(),
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            await delete(url, headers: headers)
                .decode(with: decoder)
                .mapToNetworkError()
        }

        /// Send a delete request to a `URL`
        /// - Parameters:
        ///     - url: The destination for the request
        ///     - headers: HTTP headers for the request
        /// - Returns: `Result` with `TopLevelDecodable` output and `NetworkService`'s error domain for
        /// failure
        @Sendable
        @inlinable
        public func delete<ResponseBody>(_ url: URL,
                                         headers: HTTPFields = HTTPFields()) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await delete(url, headers: headers, decoder: ResponseBody.decoder)
        }
    }
#endif
