// NetworkServiceClient+Post.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation

extension NetworkServiceClient {
    // MARK: POST

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    public func post(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<Data, Failure> {
        var request = URLRequest(url: url)
        request.httpBody = body
        request.method = .POST
        headers.forEach { request.addValue($0) }
        return start(request)
    }

    /// - Parameters:
    ///   - body: The body of the request as `Encodable`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    ///   - encoder: `TopLevelEncoder` for encoding the request body
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    public func post<RequestBody, Encoder>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader],
        encoder: Encoder
    ) -> AnyPublisher<Data, Failure>
        where RequestBody: Encodable,
        Encoder: TopLevelEncoder,
        Encoder.Output == Data
    {
        do {
            let body = try encoder.encode(body)
            return post(body, to: url, headers: headers)
        } catch {
            return Fail(error: Failure.cocoa(error as NSError))
                .eraseToAnyPublisher()
        }
    }

    /// - Parameters:
    ///   - body: The body of the request as `TopLevelEnodable`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `Data` output and `NetworkService`'s error domain for failure
    public func post<RequestBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader]
    ) -> AnyPublisher<Data, Failure>
        where RequestBody: TopLevelEncodable
    {
        do {
            let body = try RequestBody.encoder.encode(body)
            return post(body, to: url, headers: headers)
        } catch {
            return Fail(error: Failure.cocoa(error as NSError))
                .eraseToAnyPublisher()
        }
    }

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
        where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
    {
        var request = URLRequest(url: url)
        request.httpBody = body
        request.method = .POST
        headers.forEach { request.addValue($0) }
        return start(request, with: decoder)
    }

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `TopLevelDecodable` output and `NetworkService`'s error domain for failure
    public func post<ResponseBody>(
        _ body: Data,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<ResponseBody, Failure>
        where ResponseBody: TopLevelDecodable
    {
        post(body, to: url, headers: headers, decoder: ResponseBody.decoder)
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
        Decoder.Input == Data
    {
        do {
            let body = try encoder.encode(body)
            return post(body, to: url, headers: headers, decoder: decoder)
        } catch {
            return Fail(error: Failure.cocoa(error as NSError))
                .eraseToAnyPublisher()
        }
    }

    /// Send a post request to a `URL`
    /// - Parameters:
    ///   - body: The body of the request as a `TopLevelEnodable` conforming type
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `TopLevelDecodable` output and `NetworkService`'s error domain for failure
    public func post<RequestBody, ResponseBody>(
        _ body: RequestBody,
        to url: URL,
        headers: [HTTPHeader] = []
    ) -> AnyPublisher<ResponseBody, Failure>
        where RequestBody: TopLevelEncodable,
        ResponseBody: TopLevelDecodable
    {
        post(body, to: url, headers: headers, encoder: RequestBody.encoder, decoder: ResponseBody.decoder)
    }
}
