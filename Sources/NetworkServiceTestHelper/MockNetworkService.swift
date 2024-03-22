// MockNetworkService.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Combine)
    import Combine
    import CombineSchedulers
    import Foundation
    import NetworkService

    /// Convenience implementation of `NetworkServiceClient` for testing. Supports defining set output values for all
    /// network functions,
    /// repeating values, and delaying values.
    open class MockNetworkService<T: Scheduler>: NetworkServiceClient {
        public var delay: Delay
        public var outputs: [any MockOutput]
        var nextOutput: (any MockOutput)?
        let scheduler: T

        public init(outputs: [any MockOutput] = [], delay: Delay = .none, scheduler: T) {
            self.outputs = outputs
            self.delay = delay
            self.scheduler = scheduler
        }

        /// Manages the output queue and returns the new value for reach iteration.
        open func queue() throws -> any MockOutput {
            guard outputs.count > 0 else {
                throw Errors.noOutputQueued
            }
            let next = outputs.removeFirst()
            if let repeated = next as? RepeatResponse {
                switch repeated {
                case let .repeat(value, count: count):
                    if count > 1 {
                        outputs.insert(RepeatResponse.repeat(value, count: count - 1), at: 0)
                    }
                case .repeatInfinite:
                    outputs.insert(repeated, at: 0)
                }
            }
            return next
        }

        /// Replaces default implementation from protocol. All `NetworkService` functions should eventually end up in
        /// this
        /// version of `start`.
        /// Delay and repeat are handled here.
        open func start(_: URLRequest) async -> Result<Data, Failure> {
            let next: any MockOutput
            do {
                next = try queue()
            } catch {
                return .failure(Failure.unknown(error as NSError))
            }
            switch delay {
            case .infinite:
                return await Task {
                    try await scheduler.sleep(for: .seconds(.max))
                    return try next.output.get()
                }
                .result.mapToNetworkError()
            case .seconds:
                return await Task {
                    try await scheduler.sleep(for: .seconds(delay.interval))
                    return try next.output.get()
                }
                .result.mapToNetworkError()
            case .none:
                // Setting the delay publisher to zero seconds was buggy.
                // It works better to not add delay for `none`.
                return next.output
            }
        }

        public enum Errors: Error, Hashable, Sendable {
            case noOutputQueued
        }
    }
#endif
