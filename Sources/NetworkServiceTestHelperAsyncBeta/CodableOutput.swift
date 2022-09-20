// CodableOutput.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkServiceAsyncBeta

#if canImport(Combine)
    import Combine
    /// Fundamental wrapper for output values so they can easily be handled by `MockNetworkService`
    public struct CodableOutput<Output: Codable, Encoder: TopLevelEncoder, Decoder: TopLevelDecoder>: MockOutput
        where Encoder.Output == Data, Decoder.Input == Data
    {
        public var output: Result<Data, NetworkService.Failure> {
            // swiftlint:disable:next force_try
            .success(try! encoder.encode(value))
        }

        let value: Output
        let encoder: Encoder

        public init(_ value: Output, encoder: Encoder) {
            self.value = value
            self.encoder = encoder
        }
    }
#endif
