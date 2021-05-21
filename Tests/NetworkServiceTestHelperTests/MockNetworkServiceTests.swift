//
//  File.swift
//  
//
//  Created by Andrew Roan on 5/21/21.
//

import Foundation
import XCTest
import Combine
import NetworkServiceTestHelper
import NetworkService

struct MockingBird: CustomCodable, MockOutput, Equatable {
    var output: Result<Data, MockNetworkService.Failure> {
        .success(try! Self.encoder.encode(self))
    }
    
    let chirp: Bool

    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
}

final class NetworkServiceTestHelper: XCTestCase {
    var cancellables = [AnyCancellable]()

    func testQueueInfiniteRepeat() throws {
        let mock = MockNetworkService()
        mock.outputs = [MockNetworkService.RepeatResponse.repeatInfinite(MockingBird(chirp: true))]
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
            wait(for: [receiveOutput], timeout: 1)
        }
        assert(mock.outputs.count == 1, "Queued outputs should only be one element.")
        let queuedOutput = try XCTUnwrap(mock.outputs.first as? MockNetworkService.RepeatResponse)
        switch queuedOutput {
        case .repeat:
            XCTFail("Queued output is wrong value")
        case .repeatInfinite(let output):
            assert(output as? MockingBird == MockingBird(chirp: true), "Queued output matches expectation")
        }
    }

    func testQueueFiniteRepeat() throws {
        let mock = MockNetworkService()
        mock.outputs = [MockNetworkService.RepeatResponse.repeat(MockingBird(chirp: true), count: 5)]
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
            wait(for: [receiveOutput], timeout: 1)
        }
        assert(mock.outputs.isEmpty, "Output queue is empty after the specified number of repititions")
    }

    func testFiniteDelay() throws {
        let mock = MockNetworkService()
        mock.delay = MockNetworkService.Delay.seconds(2)
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
        let mock = MockNetworkService()
        mock.delay = MockNetworkService.Delay.infinite
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
