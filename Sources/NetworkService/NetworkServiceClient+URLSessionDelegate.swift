//
//  NetworkServiceClient+URLSessionDelegate.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation
import Combine

extension NetworkServiceClient where Self: URLSessionDelegate {
    // `URLSessionDelegate` does not work with `URLSession.DataTaskPublisher` so wrapping a `URLSessionDataTask` in a publisher is required.
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
                    // But that's not very helpful either. This should never happen so polluting error domain with `unknown` doesn't feel right.
                    callback(.success((data: Data(), response: URLResponse())))
                }
                return
            })
            task.resume()
        }}
        .tryHTTPMap()
        .mapToNetworkError()
        .eraseToAnyPublisher()
    }
}