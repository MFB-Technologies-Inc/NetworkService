// NetworkServiceClient+Put.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

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
        headers: [any HTTPHeader] = []
    ) async -> Result<Data, Failure> {
        let request = URLRequest.build(url: url, body: body, headers: headers, method: .PUT)
        return await start(request)
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
        public func put<RequestBody, Encoder>(
            _ body: RequestBody,
            to url: URL,
            headers: [any HTTPHeader],
            encoder: Encoder
        ) async -> Result<Data, Failure>
            where RequestBody: Encodable,
            Encoder: TopLevelEncoder,
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
            headers: [any HTTPHeader]
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
            headers: [any HTTPHeader] = [],
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
            headers: [any HTTPHeader] = []
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
        public func put<RequestBody, ResponseBody, Encoder, Decoder>(
            _ body: RequestBody,
            to url: URL,
            headers: [any HTTPHeader] = [],
            encoder: Encoder,
            decoder: Decoder
        ) async -> Result<ResponseBody, Failure>
            where RequestBody: Encodable,
            ResponseBody: Decodable,
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
            headers: [any HTTPHeader] = []
        ) async -> Result<ResponseBody, Failure>
            where RequestBody: TopLevelEncodable,
            ResponseBody: TopLevelDecodable
        {
            await put(body, to: url, headers: headers, encoder: RequestBody.encoder, decoder: ResponseBody.decoder)
        }
    }
#endif
