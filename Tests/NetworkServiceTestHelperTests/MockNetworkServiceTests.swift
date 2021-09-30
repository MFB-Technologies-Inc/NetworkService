//
//  MockNetworkServiceTests.swift
//  NetworkServiceTestHelperTests
//  
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import XCTest
import Combine
import CombineSchedulers
import NetworkServiceTestHelper
import NetworkService

struct MockingBird: CustomCodable, MockOutput, Equatable {
    var output: Result<Data, NetworkService.Failure> {
        .success(try! Self.encoder.encode(self))
    }
    
    let chirp: Bool

    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
}

final class NetworkServiceTestHelper: XCTestCase {
    typealias Failure = MockNetworkService<AnySchedulerOf<DispatchQueue>>.Failure
    
    var cancellables = [AnyCancellable]()
    let scheduler: AnySchedulerOf<DispatchQueue> = DispatchQueue.global(qos: .userInteractive).eraseToAnyScheduler()

    override func tearDown() {
        self.cancellables.forEach { $0.cancel() }
    }

    func testQueueInfiniteRepeat() throws {
        let mock = MockNetworkService(scheduler: scheduler)
        mock.outputs = [RepeatResponse.repeatInfinite(MockingBird(chirp: true))]
        for _ in 0..<5 {
            let receiveOutput = expectation(description: "Async output received")
            mock.start(URLRequest(url: URL(string: "/")!))
                .decode(type: MockingBird.self, decoder: JSONDecoder())
                .assertNoFailure()
                .sink { output in
                    assert(output == MockingBird(chirp: true), "Received output matches expected for very many interations")
                    receiveOutput.fulfill()
                }
                .store(in: &self.cancellables)
            wait(for: [receiveOutput], timeout: 2)
        }
        assert(mock.outputs.count == 1, "Queued outputs should only be one element.")
        let queuedOutput = try XCTUnwrap(mock.outputs.first as? RepeatResponse)
        switch queuedOutput {
        case .repeat:
            XCTFail("Queued output is wrong value")
        case .repeatInfinite(let output):
            assert(output as? MockingBird == MockingBird(chirp: true), "Queued output matches expectation")
        }
    }

    func testQueueFiniteRepeat() throws {
        let mock = MockNetworkService(scheduler: scheduler)
        mock.outputs = [RepeatResponse.repeat(MockingBird(chirp: true), count: 5)]
        for _ in 0..<5 {
            let receiveOutput = expectation(description: "Async output received")
            mock.start(URLRequest(url: URL(string: "/")!))
                .decode(type: MockingBird.self, decoder: JSONDecoder())
                .assertNoFailure()
                .sink { output in
                    assert(output == MockingBird(chirp: true), "Received output matches expected for very many iterations")
                    receiveOutput.fulfill()
                }
                .store(in: &self.cancellables)
            wait(for: [receiveOutput], timeout: 2)
        }
        assert(mock.outputs.isEmpty, "Output queue is empty after the specified number of repititions")
    }

    func testFiniteDelay() throws {
        let mock = MockNetworkService(scheduler: scheduler)
        mock.delay = Delay.seconds(2)
        mock.outputs = [MockingBird(chirp: true)]
        let receiveOutput = expectation(description: "Async output received")
        let startTime = Date()
        mock.start(URLRequest(url: URL(string: "/")!))
            .decode(type: MockingBird.self, decoder: JSONDecoder())
            .assertNoFailure()
            .sink { output in
                assert(output == MockingBird(chirp: true), "Received output matches expected for very many interations")
                receiveOutput.fulfill()
            }
            .store(in: &self.cancellables)
        wait(for: [receiveOutput], timeout: 5)
        let endTime = Date()
        let duration = startTime.distance(to: endTime)
        assert(duration > 2 && duration < 3, "Elapsed time is greater than the set delay with a margin of error of 1 second.")
    }

    func testInfiniteDelay() throws {
        let mock = MockNetworkService(scheduler: scheduler)
        mock.delay = Delay.infinite
        mock.outputs = [MockingBird(chirp: true)]
        let receiveOutput = expectation(description: "Async output received")
        receiveOutput.isInverted = true
        mock.start(URLRequest(url: URL(string: "/")!))
            .decode(type: MockingBird.self, decoder: JSONDecoder())
            .assertNoFailure()
            .sink { output in
                assert(output == MockingBird(chirp: true), "Received output matches expected for very many interations")
                receiveOutput.fulfill()
            }
            .store(in: &self.cancellables)
        wait(for: [receiveOutput], timeout: 2)
    }
}
