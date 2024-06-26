// Delay.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

/// Represents the amount of async delay should be added to the mocked network functions. Consider replacing with
/// `DispatchTimeInterval`.
/// Although, there is no included case for zero/none.
public enum Delay: Hashable, Sendable, Codable {
    case infinite
    case seconds(Int)
    case none

    /// The delay in `DispatchTimeInterval` for use in schedulars
    var interval: Int {
        switch self {
        case .infinite:
            .max
        case let .seconds(seconds):
            seconds
        case .none:
            0
        }
    }
}
