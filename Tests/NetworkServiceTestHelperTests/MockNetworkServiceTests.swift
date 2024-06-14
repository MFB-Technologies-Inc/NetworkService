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
    import ConcurrencyExtras
    import CustomDump
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
        try XCTUnwrap(URL(string: "https://example.com"))
    }

    final class NetworkServiceTestHelperTests: XCTestCase {
        var cancellables = [AnyCancellable]()
        func scheduler() -> AnySchedulerOf<DispatchQueue> {
            DispatchQueue.global(qos: .userInteractive).eraseToAnyScheduler()
        }

        override func tearDown() {
            cancellables.forEach { $0.cancel() }
        }

        func testQueueInfiniteRepeat() async throws {
            let mock = MockNetworkService(scheduler: scheduler())
            let client = NetworkServiceClient.mock(mock)
            await mock.set(outputs: [RepeatResponse.repeatInfinite(MockingBird.chirp)])
            for _ in 0 ..< 5 {
                let result: Result<MockingBird, NetworkServiceError> = try await client.get(url())
                XCTAssertEqual(try result.get(), .chirp)
            }
            let firstOutput = await mock.outputs.first
            let queuedOutput = try XCTUnwrap(firstOutput as? RepeatResponse)
            switch queuedOutput {
            case .repeat:
                XCTFail("Queued output is wrong value")
            case let .repeatInfinite(output):
                XCTAssertEqual(output as? MockingBird, MockingBird.chirp, "Queued output matches expectation")
            }
        }

        func testQueueFiniteRepeat() async throws {
            let mock = MockNetworkService(scheduler: scheduler())
            let client = NetworkServiceClient.mock(mock)
            await mock.set(outputs: [RepeatResponse.repeat(MockingBird(chirp: true), count: 5)])
            for _ in 0 ..< 5 {
                let result: Result<MockingBird, NetworkServiceError> = try await client.get(url())
                XCTAssertEqual(try result.get(), .chirp)
            }
            let isOutputsEmpty = await mock.outputs.isEmpty
            XCTAssert(isOutputsEmpty, "Output queue is empty after the specified number of repititions")
        }

        func testFiniteDelay() async throws {
            let mock = MockNetworkService(scheduler: scheduler())
            let client = NetworkServiceClient.mock(mock)
            await mock.set(delay: .seconds(2))
            await mock.set(outputs: [MockingBird.chirp])
            let startTime = Date()
            let result: Result<MockingBird, NetworkServiceError> = try await client.get(url())
            let endTime = Date()
            let duration = startTime.distance(to: endTime)
            XCTAssertGreaterThan(duration, 2)
            XCTAssertLessThan(duration, 3)
            XCTAssertEqual(try result.get(), MockingBird.chirp)
        }

        func testInfiniteDelay() async throws {
            let scheduler = scheduler()
            let mock = MockNetworkService(scheduler: scheduler)
            let client = NetworkServiceClient.mock(mock)
            await mock.set(delay: .infinite)
            await mock.set(outputs: [MockingBird.chirp])
            let expectation = expectation(description: "Never receive a response")
            expectation.isInverted = true
            let task = Task {
                let result: Result<MockingBird, NetworkServiceError> = try await client.get(url())
                XCTAssertEqual(try result.get(), MockingBird.chirp)
                expectation.fulfill()
            }
            #if swift(>=5.8)
                await fulfillment(of: [expectation], timeout: 2)
            #else
                wait(for: [expectation], timeout: 2)
            #endif
            task.cancel()
        }
    }
#endif
