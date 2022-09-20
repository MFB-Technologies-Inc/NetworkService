//
//  File.swift
//  
//
//  Created by andrew on 9/20/22.
//

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
