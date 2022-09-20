// MockOutput.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkServiceAsyncBeta

/// A type erasing protocol for `MockNetworkService`'s output queue. Allows a heterogenous array.
public protocol MockOutput {
    var output: Result<Data, NetworkService.Failure> { get }
}

extension Data: MockOutput {
    public var output: Result<Data, NetworkService.Failure> {
        .success(self)
    }
}

extension NetworkService.Failure: MockOutput {
    public var output: Result<Data, Self> {
        .failure(self)
    }
}

#if canImport(Combine)
    extension MockOutput where Self: TopLevelEncodable {
        public var output: Result<Data, NetworkService.Failure> {
            // swiftlint:disable:next force_try
            let data = try! Self.encoder.encode(self)
            return .success(data)
        }
    }
#endif
