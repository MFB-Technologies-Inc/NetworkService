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
    import HTTPTypes
    import NetworkService

    /// Convenience implementation of `NetworkServiceClient` for testing. Supports defining set output values for all
    /// network functions,
    /// repeating values, and delaying values.
    public actor MockNetworkService<T>: Sendable where T: Scheduler, T: Sendable {
        public var delay: Delay
        public var outputs: [any MockOutput]
        public var nextOutput: (any MockOutput)?
        public let scheduler: T

        public func set(delay: Delay) {
            self.delay = delay
        }

        public func set(outputs: [any MockOutput]) {
            self.outputs = outputs
        }

        public func set(nextOutput: (any MockOutput)?) {
            self.nextOutput = nextOutput
        }

        public init(delay: Delay = .none, outputs: [any MockOutput] = [], scheduler: T) {
            self.delay = delay
            nextOutput = nil
            self.outputs = outputs
            self.scheduler = scheduler
        }

        /// Manages the output queue and returns the new value for reach iteration.
        public func queue() throws -> any MockOutput {
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
        public func start(_: HTTPRequest, body _: Data?) async -> Result<Data, NetworkServiceError> {
            let next: any MockOutput
            do {
                next = try queue()
            } catch {
                return .failure(.unknown(error as NSError))
            }
            let output = next.output
            switch delay {
            case .infinite:

                return await Task { [scheduler] in
                    do {
                        try await scheduler.sleep(for: .seconds(.max))
                    } catch {
                        return Result<Data, any Error>.failure(error)
                            .mapToNetworkError()
                    }
                    return output
                }.value
            case .seconds:
                return await Task { [delay, scheduler] in
                    do {
                        try await scheduler.sleep(for: .seconds(delay.interval))
                    } catch {
                        return Result<Data, any Error>.failure(error)
                            .mapToNetworkError()
                    }
                    return output
                }.value
            case .none:
                return output
            }
        }

        public enum Errors: Error, Hashable, Sendable {
            case noOutputQueued
        }
    }
#endif
