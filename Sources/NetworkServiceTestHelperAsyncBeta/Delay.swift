//
//  File.swift
//  
//
//  Created by andrew on 9/20/22.
//

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
