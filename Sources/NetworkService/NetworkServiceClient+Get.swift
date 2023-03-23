// NetworkServiceClient+Get.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension NetworkServiceClient {
    // MARK: GET

    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    public func get(
        _ url: URL,
        headers: [HTTPHeader] = []
    ) async -> Result<Data, Failure> {
        let request = URLRequest.build(url: url, headers: headers, method: .GET)
        return await start(request)
    }
}

#if canImport(Combine)
    import Combine
    extension NetworkServiceClient {
        /// Send a get request to a `URL`
        /// - Parameters:
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        ///   - decoder:`TopLevelDecoder` for decoding the response body
        /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
        public func get<ResponseBody, Decoder>(
            _ url: URL,
            headers: [HTTPHeader] = [],
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            await get(url, headers: headers)
                .decode(with: decoder)
                .mapToNetworkError()
        }

        /// Send a get request to a `URL`
        /// - Parameters:
        ///     - url: The destination for the request
        ///     - headers: HTTP headers for the request
        /// - Returns: Type erased publisher with `TopLevelDecodable` output and `NetworkService`'s error domain for
        /// failure
        public func get<ResponseBody>(_ url: URL, headers: [HTTPHeader] = []) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await get(url, headers: headers, decoder: ResponseBody.decoder)
        }
    }
#endif
