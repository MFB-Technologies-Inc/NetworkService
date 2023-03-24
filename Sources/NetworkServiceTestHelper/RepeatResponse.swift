// RepeatResponse.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkService

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
