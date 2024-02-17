// MockNetworkServiceTests.swift
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
    import NetworkServiceTestHelper
    import XCTest

    struct MockingBird: TopLevelCodable, MockOutput, Equatable {
        let chirp: Bool

        static let encoder = JSONEncoder()
        static let decoder = JSONDecoder()

        static let chirp: Self = MockingBird(chirp: true)
        static let notChirp: Self = MockingBird(chirp: false)
    }

    func url() throws -> URL {
        try XCTUnwrap(URL(string: "/"))
    }

    final class NetworkServiceTestHelper: XCTestCase {
        typealias Failure = MockNetworkService<AnySchedulerOf<DispatchQueue>>.Failure

        var cancellables = [AnyCancellable]()
        let scheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.global(qos: .userInteractive).eraseToAnyScheduler()

        override func tearDown() {
            cancellables.forEach { $0.cancel() }
        }

        func testQueueInfiniteRepeat() async throws {
            let mock = MockNetworkService(scheduler: scheduler)
            mock.outputs = [RepeatResponse.repeatInfinite(MockingBird.chirp)]
            for _ in 0 ..< 5 {
                let result: Result<MockingBird, NetworkService.Failure> = try await mock.get(url())
                XCTAssertEqual(try result.get(), .chirp)
            }
            let queuedOutput = try XCTUnwrap(mock.outputs.first as? RepeatResponse)
            switch queuedOutput {
            case .repeat:
                XCTFail("Queued output is wrong value")
            case let .repeatInfinite(output):
                XCTAssertEqual(output as? MockingBird, MockingBird.chirp, "Queued output matches expectation")
            }
        }

        func testQueueFiniteRepeat() async throws {
            let mock = MockNetworkService(scheduler: scheduler)
            mock.outputs = [RepeatResponse.repeat(MockingBird(chirp: true), count: 5)]
            for _ in 0 ..< 5 {
                let result: Result<MockingBird, NetworkService.Failure> = try await mock.get(url())
                XCTAssertEqual(try result.get(), .chirp)
            }
            XCTAssert(mock.outputs.isEmpty, "Output queue is empty after the specified number of repititions")
        }

        func testFiniteDelay() async throws {
            let mock = MockNetworkService(scheduler: scheduler)
            mock.delay = Delay.seconds(2)
            mock.outputs = [MockingBird.chirp]
            let startTime = Date()
            let result: Result<MockingBird, NetworkService.Failure> = try await mock.get(url())
            let endTime = Date()
            let duration = startTime.distance(to: endTime)
            XCTAssertGreaterThan(duration, 2)
            XCTAssertLessThan(duration, 3)
            XCTAssertEqual(try result.get(), MockingBird.chirp)
        }

        func testInfiniteDelay() async throws {
            let mock = MockNetworkService(scheduler: scheduler)
            mock.delay = Delay.infinite
            mock.outputs = [MockingBird.chirp]
            let expectation = expectation(description: "Never receive a response")
            expectation.isInverted = true
            let task = Task {
                let result: Result<MockingBird, NetworkService.Failure> = try await mock.get(url())
                XCTAssertEqual(try result.get(), MockingBird.chirp)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 2)
            task.cancel()
        }
    }
#endif
