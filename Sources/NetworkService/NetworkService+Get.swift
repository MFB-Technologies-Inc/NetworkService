//
//  File.swift
//  
//
//  Created by Andrew Roan on 4/27/21.
//

import Foundation
import Combine

extension NetworkService {
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
    where ResponseBody: Decodable, Decoder: TopLevelDecoder, Decoder.Input == Data {
        get(url, headers: headers)
            .decode(with: decoder)
            .mapToNetworkError()
            .eraseToAnyPublisher()
    }

    /// Send a get request to a `URL`
    /// - Parameters:
    ///     - url: The destination for the request
    ///     - headers: HTTP headers for the request
    /// - Returns: Type erased publisher with `CustomDecodable` output and `NetworkService`'s error domain for failure
    public func get<ResponseBody>(_ url: URL, headers: [HTTPHeader] = []) -> AnyPublisher<ResponseBody, Failure>
    where ResponseBody: CustomDecodable, ResponseBody.CustomDecoder.Input == Data {
        get(url, headers: headers, decoder: ResponseBody.decoder)
    }

}
