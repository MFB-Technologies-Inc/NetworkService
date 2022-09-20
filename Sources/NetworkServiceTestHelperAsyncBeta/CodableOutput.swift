//
//  File.swift
//  
//
//  Created by andrew on 9/20/22.
//

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
