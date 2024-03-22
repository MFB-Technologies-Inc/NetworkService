// FailureOutput.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkService

/// Wraps a provided error for use as output
@available(*, deprecated, message: "To be removed in next major version")
public struct FailureOutput<T>: MockOutput where T: Error {
    @available(*, deprecated, message: "To be removed in next major version")
    public var output: Result<Data, NetworkService.Failure> {
        if let networkFailure = error as? NetworkService.Failure {
            return .failure(networkFailure)
        }
        return .failure(.unknown(error as NSError))
    }

    @available(*, deprecated, message: "To be removed in next major version")
    public let error: T

    @available(*, deprecated, message: "To be removed in next major version")
    public init(error: T) {
        self.error = error
    }
}
