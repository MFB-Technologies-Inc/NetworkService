// RepeatResponse.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import NetworkService

/// Wraps a given output value to define how many times it should be repeated.
public enum RepeatResponse: MockOutput {
    case `repeat`(any MockOutput, count: Int)
    case repeatInfinite(any MockOutput)

    public var output: Result<Data, NetworkService.Failure> {
        switch self {
        case .repeat(let output, count: _), let .repeatInfinite(output):
            output.output
        }
    }
}
