//
//  File.swift
//  
//
//  Created by andrew on 9/20/22.
//

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
