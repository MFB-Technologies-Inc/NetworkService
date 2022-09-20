//
//  File.swift
//  
//
//  Created by andrew on 9/20/22.
//

import Foundation
import NetworkServiceAsyncBeta

/// Wraps a given output value to define how many times it should be repeated.
public enum RepeatResponse: MockOutput {
    case `repeat`(MockOutput, count: Int)
    case repeatInfinite(MockOutput)

    public var output: Result<Data, NetworkService.Failure> {
        switch self {
        case .repeat(let output, count: _), let .repeatInfinite(output):
            return output.output
        }
    }
}
