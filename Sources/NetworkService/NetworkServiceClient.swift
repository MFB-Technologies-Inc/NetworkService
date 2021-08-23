//
//  NetworkServiceClient.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/22/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import Combine

/// Dependency injection point for `NetworkService`
public protocol NetworkServiceClient {
    /// `NetworkService`'s error domain
    typealias Failure = NetworkService.Failure

    // MARK: Get Session
    /// - Returns: Configured URLSession
    func getSession() -> URLSession

    // MARK: DELETE
    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
     func delete(
        _ url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>

    /// Send a delete request to a `URL`
    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder: `TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func delete<ResponseBody, Decoder>(
        _ url: URL,
        headers: [HTTPHeader],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data

    /// Send a delete request to a `URL`
    /// - Parameters:
    ///     - url: The destination for the request
    ///     - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
     func delete<ResponseBody>(_ url: URL, headers: [HTTPHeader]) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data

    // MARK: GET
    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
     func get(
        _ url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>

    /// Send a get request to a `URL`
    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func get<ResponseBody, Decoder>(
        _ url: URL,
        headers: [HTTPHeader],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data

    /// Send a get request to a `URL`
    /// - Parameters:
    ///     - url: The destination for the request
    ///     - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    func get<ResponseBody>(_ url: URL, headers: [HTTPHeader]) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data

    // MARK: POST
    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
     func post(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>

    /// - Parameters:
    ///   - body: The body of the request as `Encodable`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder: `TopLevelEncoder` for encoding the request body
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    func post<RequestBody, Encoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: Encodable,
    Encoder: TopLevelEncoder,
    Encoder.Output == Data

    /// - Parameters:
    ///   - body: The body of the request as `CustomEncodable`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    func post<RequestBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: CustomEncodable,
          RequestBody.CustomEncoder.Output == Data

    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func post<ResponseBody, Decoder>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
     func post<ResponseBody>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data

    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `Encodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder:`TopLevelEncoder` for encoding the request body
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func post<RequestBody, ResponseBody, Encoder, Decoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder,
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: Encodable,
          ResponseBody: Decodable,
          Encoder: TopLevelEncoder,
          Encoder.Output == Data,
          Decoder: TopLevelDecoder,
          Decoder.Input == Data

    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `CustomEncodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
     func post<RequestBody, ResponseBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: CustomEncodable,
          ResponseBody: CustomDecodable,
          RequestBody.CustomEncoder.Output == Data,
          ResponseBody.CustomDecoder.Input == Data

    // MARK: PUT
    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
     func put(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>

    /// - Parameters:
    ///   - body: The body of the request as `Encodable`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder: `TopLevelEncoder` for encoding the request body
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    func put<RequestBody, Encoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: Encodable,
    Encoder: TopLevelEncoder,
    Encoder.Output == Data

    /// - Parameters:
    ///   - body: The body of the request as `CustomEncodable`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    func put<RequestBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: CustomEncodable,
          RequestBody.CustomEncoder.Output == Data

    /// Send a put request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func put<ResponseBody, Decoder>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
     func put<ResponseBody>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data

    /// Send a put request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `Encodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder:`TopLevelEncoder` for encoding the request body
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func put<RequestBody, ResponseBody, Encoder, Decoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder,
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: Encodable,
          ResponseBody: Decodable,
          Encoder: TopLevelEncoder,
          Encoder.Output == Data,
          Decoder: TopLevelDecoder,
          Decoder.Input == Data

    /// Send a put request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `Encodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func put<RequestBody, ResponseBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: CustomEncodable,
          ResponseBody: CustomDecodable,
          RequestBody.CustomEncoder.Output == Data,
          ResponseBody.CustomDecoder.Input == Data

    // MARK: URLRequest
    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
     func start<ResponseBody, Decoder>(
        _ request: URLRequest,
        with decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data

    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    func start<ResponseBody>(_ request: URLRequest) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data

    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with output as `Data` and `NetworkService`'s error domain for failure
    func start(_ request: URLRequest) -> AnyPublisher<Data, Failure>
}
