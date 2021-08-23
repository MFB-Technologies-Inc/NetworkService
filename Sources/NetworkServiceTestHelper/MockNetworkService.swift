//
//  MockNetworkService.swift
//  NetworkServiceTestHelper
//
//  Created by Andrew Roan on 5/21/21.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import Combine
import NetworkService
import CombineSchedulers

/// Convenience implementation of `NetworkServiceClient` for testing. Supports defining set output values for all network functions, repeating values, and delaying values.
open class MockNetworkService<T: Scheduler>: NetworkServiceClient {
    public var delay: Delay
    public var outputs: [MockOutput]
    var nextOutput: MockOutput? = nil
    let scheduler: T

    public init(outputs: [MockOutput] = [], delay: Delay = .none, scheduler: T) {
        self.outputs = outputs
        self.delay = delay
        self.scheduler = scheduler
    }

    /// Manages the output queue and returns the new value for reach iteration.
    private func queue() -> MockOutput {
        guard outputs.count > 0 else {
            fatalError("No outputs queued")
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

    /// Replaces default implementation from protocol. All `NetworkService` functions should eventually end up in this version of `start`. Delay and repeat are handled here.
    public func start(_ request: URLRequest) -> AnyPublisher<Data, Failure> {
        let next = queue()
        switch delay {
        case .infinite, .seconds:
            return next.output.publisher
                .delay(
                    for: T.SchedulerTimeType.Stride.seconds(delay.interval),
                    scheduler: self.scheduler
                )
                .receive(on: self.scheduler)
                .eraseToAnyPublisher()
        case .none:
            // Setting the delay publisher to zero seconds was buggy.
            // It works better to not add delay for `none`.
            return next.output.publisher.eraseToAnyPublisher()
        }
    }
}

/// Represents the amount of async delay should be added to the mocked network functions. Consider replacing with `DispatchTimeInterval`. Although, there is no included case for zero/none.
public enum Delay {
    case infinite
    case seconds(Int)
    case none

    /// The delay in `DispatchTimeInterval` for use in schedulars
    var interval: Int {
        switch self {
        case .infinite:
            return .max
        case .seconds(let seconds):
            return seconds
        case .none:
            return 0
        }
    }
}

/// Wraps a given output value to define how many times it should be repeated.
public enum RepeatResponse: MockOutput {
    case `repeat`(MockOutput, count: Int)
    case repeatInfinite(MockOutput)

    public var output: Result<Data, NetworkService.Failure> {
        switch self {
        case .repeat(let output, count: _), .repeatInfinite(let output):
            return output.output
        }
    }
}

/// Fundamental wrapper for output values so they can easily be handled by `MockNetworkService`
public struct CodableOutput<Output: Codable, Encoder: TopLevelEncoder, Decoder: TopLevelDecoder>: MockOutput where Encoder.Output == Data, Decoder.Input == Data {
    public var output: Result<Data, NetworkService.Failure> {
        .success(try! encoder.encode(value))
    }
    let value: Output
    let encoder: Encoder

    public init(_ value: Output, encoder: Encoder) {
        self.value = value
        self.encoder = encoder
    }
}

/// A type erasing protocol for `MockNetworkService`'s output queue. Allows a heterogenous array.
public protocol MockOutput {
    var output: Result<Data, NetworkService.Failure> { get }
}

extension MockOutput where Self: CustomEncodable, CustomEncoder.Output == Data {
    var output: Result<Data, NetworkService.Failure> {
        let data = try! Self.encoder.encode(self)
        return .success(data)
    }
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
