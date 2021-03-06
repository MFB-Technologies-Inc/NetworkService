// NetworkServiceClient+Get.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
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
    ) -> AnyPublisher<Data, Failure> {
        var request = URLRequest(url: url)
        request.method = .GET
        headers.forEach { request.addValue($0) }
        return start(request)
    }

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
    ) -> AnyPublisher<ResponseBody, Failure>
        where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
    {
        get(url, headers: headers)
            .decode(with: decoder)
            .mapToNetworkError()
            .eraseToAnyPublisher()
    }

    /// Send a get request to a `URL`
    /// - Parameters:
    ///     - url: The destination for the request
    ///     - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `TopLevelDecodable` output and `NetworkService`'s error domain for failure
    public func get<ResponseBody>(_ url: URL, headers: [HTTPHeader] = []) -> AnyPublisher<ResponseBody, Failure>
        where ResponseBody: TopLevelDecodable
    {
        get(url, headers: headers, decoder: ResponseBody.decoder)
    }
}
