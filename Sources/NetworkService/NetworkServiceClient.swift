// NetworkServiceClient.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import HTTPTypes

/// Dependency injection point for `NetworkService`
public protocol NetworkServiceClient {
    /// `NetworkService`'s error domain
    typealias Failure = NetworkService.Failure

    /// - Returns: Configured URLSession
    func getSession() -> URLSession

    /// Start a `HTTPRequest` as a `HTTPRequest`
    /// - Parameters:
    ///     - request: The request as a `HTTPRequest`
    ///     - body: Data?
    /// - Returns: Result with output as `Data` and `NetworkService`'s error domain for failure
    func start(_ request: HTTPRequest, body: Data?) async -> Result<Data, Failure>
}
