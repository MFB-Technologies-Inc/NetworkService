//
//  NetworkService.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation
import Combine

/// Provides methods for making network requests and processing the resulting responses
public class NetworkService: NSObject {
    /// `NetworkService`'s error domain
    public enum Failure: Error, Equatable {
        case url(URLResponse)
        case http(HTTPURLResponse)
        case cocoa(NSError)
    }

    // MARK: URLRequest
    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func start<ResponseBody, Decoder>(
        _ request: URLRequest,
        with decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        return getSession().dataTaskPublisher(for: request)
            .tryHTTPMap()
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

// MARK: NetworkService+NetworkServiceClient
extension NetworkService: NetworkServiceClient {}
