// Delay.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

/// Represents the amount of async delay should be added to the mocked network functions. Consider replacing with `DispatchTimeInterval`.
/// Although, there is no included case for zero/none.
public enum Delay {
    case infinite
    case seconds(Int)
    case none

    /// The delay in `DispatchTimeInterval` for use in schedulars
    var interval: Int {
        switch self {
        case .infinite:
            return .max
        case let .seconds(seconds):
            return seconds
        case .none:
            return 0
        }
    }
}
