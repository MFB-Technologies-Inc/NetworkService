// NetworkServiceClient+Put.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import HTTPTypes

extension NetworkServiceClient {
    // MARK: PUT

    /// - Parameters:
    ///   - body: The body of the request as `Data`
    ///   - url: The destination for the request
    ///   - headers: HTTP headers for the request
    /// - Returns: `Result` with `Data` output and `NetworkService`'s error domain for failure
    public func put(
        _ body: Data,
        to url: URL,
        headers: HTTPFields = HTTPFields()
    ) async -> Result<Data, Failure> {
        let request = HTTPRequest(method: .put, url: url, headerFields: headers)
        return await start(request, body: body)
    }
}

#if canImport(Combine)
    import Combine

    extension NetworkServiceClient {
        /// - Parameters:
        ///   - body: The body of the request as `Encodable`
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        ///   - encoder: `TopLevelEncoder` for encoding the request body
        /// - Returns: `Result` with `Data` output and `NetworkService`'s error domain for failure
        public func put<Encoder>(
            _ body: some Encodable,
            to url: URL,
            headers: HTTPFields,
            encoder: Encoder
        ) async -> Result<Data, Failure>
            where Encoder: TopLevelEncoder,
            Encoder.Output == Data
        {
            do {
                let body = try encoder.encode(body)
                return await put(body, to: url, headers: headers)
            } catch let urlError as URLError {
                return .failure(Failure.urlError(urlError))
            } catch {
                return .failure(Failure.unknown(error as NSError))
            }
        }

        /// - Parameters:
        ///   - body: The body of the request as `TopLevelEncodable`
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        /// - Returns: `Result` with `Data` output and `NetworkService`'s error domain for failure
        public func put<RequestBody>(
            _ body: RequestBody,
            to url: URL,
            headers: HTTPFields
        ) async -> Result<Data, Failure>
            where RequestBody: TopLevelEncodable
        {
            do {
                let body = try RequestBody.encoder.encode(body)
                return await put(body, to: url, headers: headers)
            } catch let urlError as URLError {
                return .failure(Failure.urlError(urlError))
            } catch {
                return .failure(Failure.unknown(error as NSError))
            }
        }

        /// Send a put request to a `URL`
        /// - Parameters:
        ///   - body: The body of the request as `Data`
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        ///   - decoder:`TopLevelDecoder` for decoding the response body
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        public func put<ResponseBody, Decoder>(
            _ body: Data,
            to url: URL,
            headers: HTTPFields = HTTPFields(),
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data
        {
            await put(body, to: url, headers: headers)
                .decode(with: decoder)
                .mapToNetworkError()
        }

        /// - Parameters:
        ///   - body: The body of the request as `Data`
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        /// - Returns: `Result` with `TopLevelDecodable` output and `NetworkService`'s error domain for
        /// failure
        public func put<ResponseBody>(
            _ body: Data,
            to url: URL,
            headers: HTTPFields = HTTPFields()
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: TopLevelDecodable
        {
            await put(body, to: url, headers: headers, decoder: ResponseBody.decoder)
        }

        /// Send a put request to a `URL`
        /// - Parameters:
        ///   - body: The body of the request as a `Encodable` conforming type
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        ///   - encoder:`TopLevelEncoder` for encoding the request body
        ///   - decoder:`TopLevelDecoder` for decoding the response body
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        public func put<ResponseBody, Encoder, Decoder>(
            _ body: some Encodable,
            to url: URL,
            headers: HTTPFields = HTTPFields(),
            encoder: Encoder,
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where ResponseBody: Decodable,
            Encoder: TopLevelEncoder,
            Encoder.Output == Data,
            Decoder: TopLevelDecoder,
            Decoder.Input == Data
        {
            do {
                let body = try encoder.encode(body)
                return await put(body, to: url, headers: headers, decoder: decoder)
            } catch let urlError as URLError {
                return .failure(Failure.urlError(urlError))
            } catch {
                return .failure(Failure.unknown(error as NSError))
            }
        }

        /// Send a put request to a `URL`
        /// - Parameters:
        ///   - body: The body of the request as a `Encodable` conforming type
        ///   - url: The destination for the request
        ///   - headers: HTTP headers for the request
        /// - Returns: `Result` with decoded output and `NetworkService`'s error domain for failure
        public func put<RequestBody, ResponseBody>(
            _ body: RequestBody,
            to url: URL,
            headers: HTTPFields = HTTPFields()
        ) async -> Result<ResponseBody, Failure>
            where RequestBody: TopLevelEncodable,
            ResponseBody: TopLevelDecodable
        {
            await put(body, to: url, headers: headers, encoder: RequestBody.encoder, decoder: ResponseBody.decoder)
        }
    }
#endif
