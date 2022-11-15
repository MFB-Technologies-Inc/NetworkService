// NetworkServiceClient+URLSessionDelegate.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation

extension NetworkServiceClient where Self: URLSessionDelegate {
    // `URLSessionDelegate` does not work with `URLSession.DataTaskPublisher` so wrapping a `URLSessionDataTask` in a
    // publisher is required.
    public func start(_ request: URLRequest) -> AnyPublisher<Data, Failure> {
        let session = getSession()
        return Deferred { Future<(data: Data, response: URLResponse), Failure> { callback in
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let response = response {
                    callback(.success((data: data ?? Data(), response: response)))
                } else if let error = error {
                    callback(.failure(.cocoa(error as NSError)))
                } else {
                    assertionFailure("Invalid URLResponse with no data, response, or error.")
                    // This might not be the best idea. Perhaps responding with a `Failure.unknown` is better?
                    // But that's not very helpful either. This should never happen so polluting error domain with
                    // `unknown` doesn't feel right.
                    callback(.success((data: Data(), response: URLResponse())))
                }
            })
            task.resume()
        }}
        .tryHTTPMap()
        .mapToNetworkError()
        .eraseToAnyPublisher()
    }
}
