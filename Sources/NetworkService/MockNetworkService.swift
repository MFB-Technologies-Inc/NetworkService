//
//  MockNetworkService.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/22/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation
import Combine

/// A base class for mocking of `NetworkService`. Any subclasses override and implement only the functions needed.
public class MockNetworkService: NetworkServiceClient {
    public func post<RequestBody, Encoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: Encodable, Encoder: TopLevelEncoder, Encoder.Output == Data {
        fatalError("not implemented")
    }

    public func post<RequestBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: CustomEncodable, RequestBody.CustomEncoder.Output == Data {
        fatalError("not implemented")
    }

    public func put<RequestBody, Encoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: Encodable, Encoder: TopLevelEncoder, Encoder.Output == Data {
        fatalError("not implemented")
    }

    public func put<RequestBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>
    where RequestBody: CustomEncodable, RequestBody.CustomEncoder.Output == Data {
        fatalError("not implemented")
    }

    public func delete(_ url: URL, headers: [HTTPHeader]) -> AnyPublisher<Data, Failure> {
        fatalError("not implemented")
    }

    public func get(_ url: URL, headers: [HTTPHeader]) -> AnyPublisher<Data, Failure> {
        fatalError("not implemented")
    }

    public func post(_ body: Data, to url: URL, headers: [HTTPHeader]) -> AnyPublisher<Data, Failure> {
        fatalError("not implemented")
    }

    public func put(_ body: Data, to url: URL, headers: [HTTPHeader]) -> AnyPublisher<Data, Failure> {
        fatalError("not implemented")
    }

    public func start(_ request: URLRequest) -> AnyPublisher<Data, Failure> {
        fatalError("not implemented")
    }

    // MARK: DELETE
    /// Send a delete request to a `URL`
    /// - Parameters:
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder: `TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func delete<ResponseBody, Decoder>(
        _ url: URL,
        headers: [HTTPHeader] = [],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        fatalError("not implemented")
    }

    /// Send a delete request to a `URL`
    /// - Parameters:
    ///     - url: The destination for the request
    ///     - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    public func delete<ResponseBody>(_ url: URL, headers: [HTTPHeader] = []) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
    }

    // MARK: GET
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
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        fatalError("not implemented")
    }

    /// Send a get request to a `URL`
    /// - Parameters:
    ///     - url: The destination for the request
    ///     - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    public func get<ResponseBody>(_ url: URL, headers: [HTTPHeader] = []) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
    }

    // MARK: POST
    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func post<ResponseBody, Decoder>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader] = [],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        fatalError("not implemented")
    }

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    public func post<ResponseBody>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
    }

    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `Encodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder:`TopLevelEncoder` for encoding the request body
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func post<RequestBody, ResponseBody, Encoder, Decoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader] = [],
        encoder: Encoder,
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: Encodable,
          ResponseBody: Decodable,
          Encoder: TopLevelEncoder,
          Encoder.Output == Data,
          Decoder: TopLevelDecoder,
          Decoder.Input == Data {
        fatalError("not implemented")
    }

    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `CustomEncodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    public func post<RequestBody, ResponseBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: CustomEncodable,
          ResponseBody: CustomDecodable,
          RequestBody.CustomEncoder.Output == Data,
          ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
    }

    // MARK: PUT
    /// Send a put request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func put<ResponseBody, Decoder>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader] = [],
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        fatalError("not implemented")
    }

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    public func put<ResponseBody>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
    }

    /// Send a put request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `Encodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder:`TopLevelEncoder` for encoding the request body
    ///   - decoder:`TopLevelDecoder` for decoding the response body
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func put<RequestBody, ResponseBody, Encoder, Decoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader] = [],
        encoder: Encoder,
        decoder: Decoder
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: Encodable,
          ResponseBody: Decodable,
          Encoder: TopLevelEncoder,
          Encoder.Output == Data,
          Decoder: TopLevelDecoder,
          Decoder.Input == Data {
        fatalError("not implemented")
    }

    /// Send a put request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `Encodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func put<RequestBody, ResponseBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<ResponseBody, Failure>
    where RequestBody: CustomEncodable,
          ResponseBody: CustomDecodable,
          RequestBody.CustomEncoder.Output == Data,
          ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
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
        fatalError("not implemented")
    }

    /// Start a `URLRequest`
    /// - Parameter request: The request as a `URLRequest`
    /// - Returns: Type erased publisher with decoded output and `NetworkService`'s error domain for failure
    public func start<ResponseBody>(_ request: URLRequest) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        fatalError("not implemented")
    }
}
