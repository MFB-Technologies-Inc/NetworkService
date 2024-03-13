// CodableOutput.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkService

#if canImport(Combine)
    import Combine

    /// Fundamental wrapper for output values so they can easily be handled by `MockNetworkService`
    public struct CodableOutput<Output: Codable, Encoder: TopLevelEncoder, Decoder: TopLevelDecoder>: MockOutput
        where Encoder.Output == Data, Decoder.Input == Data
    {
        public var output: Result<Data, NetworkService.Failure> {
            Result {
                try encoder.encode(value)
            }
            .mapError { error in
                .unknown(error as NSError)
            }
        }

        let value: Output
        let encoder: Encoder

        public init(_ value: Output, encoder: Encoder) {
            self.value = value
            self.encoder = encoder
        }
    }
#endif
