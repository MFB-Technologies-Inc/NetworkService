// FailureOutput.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkServiceAsyncBeta

/// Wraps a provided error for use as output
public struct FailureOutput<T>: MockOutput where T: Error {
    public var output: Result<Data, NetworkService.Failure> {
        if let networkFailure = error as? NetworkService.Failure {
            return .failure(networkFailure)
        }
        return .failure(.unknown(error as NSError))
    }

    public let error: T

    public init(error: T) {
        self.error = error
    }
}
