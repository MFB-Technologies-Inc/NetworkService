// NetworkService.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation
import HTTPTypes

/// Dependency injection point for `NetworkService`
public struct NetworkServiceClient: Sendable {
    public typealias Failure = NetworkServiceError
    
    @usableFromInline
    let _getSession: @Sendable () -> URLSession
    
    @usableFromInline
    let _start: @Sendable (_ request: HTTPRequest, _ body: Data?, _ session: URLSession) async -> Result<Data, Failure>
    
    /// - Returns: Configured URLSession
    @Sendable
    @inlinable
    public func getSession() -> URLSession {
        _getSession()
    }
    
    /// Start a `HTTPRequest` as a `HTTPRequest`
    /// - Parameters:
    ///     - request: The request as a `HTTPRequest`
    ///     - body: Data?
    /// - Returns: Result with output as `Data` and `NetworkService`'s error domain for failure
    @Sendable
    @inlinable
    public func start(_ request: HTTPRequest, body: Data?) async -> Result<Data, Failure> {
        await _start(request, body, getSession())
    }
    
    /// Default implementation of `getSession` that returns the `shared` instance
    @Sendable
    @inlinable
    public static func defaultGetSession() -> URLSession {
        URLSession.shared
    }

    public init(
        getSession: @escaping @Sendable () -> URLSession = Self.defaultGetSession,
        start: @escaping @Sendable (_ request: HTTPRequest, _ body: Data?, _ session: URLSession) async -> Result<Data, Failure> = Self.defaultStart(_:body:session:)
    ) {
        _getSession = getSession
        _start = start
    }
}
