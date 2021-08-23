//
//  NetworkServiceClient+Start.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/27/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import Combine

extension NetworkServiceClient {
    // MARK: URLRequest
    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func start<ResponseBody, Decoder>(
        _ request: URLRequest,
        with decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        return start(request)
            .decode(with: decoder)
            .mapToNetworkError()
            .eraseToAnyPublisher()
    }

    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func start<ResponseBody>(_ request: URLRequest) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        start(request, with: ResponseBody.decoder)
    }

    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with output as `Data` and `NetworkService`'s error domain for failure
    public func start(_ request: URLRequest) -> AnyPublisher<Data, Failure> {
        getSession().dataTaskPublisher(for: request)
            .tryHTTPMap()
            .mapToNetworkError()
            .eraseToAnyPublisher()
    }
}
