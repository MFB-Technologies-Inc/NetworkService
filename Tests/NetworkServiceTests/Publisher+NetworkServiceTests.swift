// Publisher+NetworkServiceTests.swift
// NetworkService
//
// Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation
import NetworkService
import XCTest

final class PublisherNetworkServiceTests: AsyncTestCase {
    // MARK: Publisher where Output == URLSession.DataTaskPublisher.Output

    func testInvalidInput() throws {
        let url = try XCTUnwrap(URL(string: "test.com"))
        let response = URLResponse(
            url: url,
            mimeType: "",
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let input = (data: Data(), response: response)
        let urlFailure = expectation(description: "fails with url error")
        Just(input)
            .tryHTTPMap()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        switch error {
                        case NetworkService.Failure.url:
                            urlFailure.fulfill()
                        default:
                            XCTFail("Incorrect error received")
                        }
                    case .finished:
                        XCTFail("Unexpected successful finish")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Unexpected successful output")
                }
            )
            .store(in: &cancellables)
        wait(for: [urlFailure], timeout: 0.1)
    }

    func testUnsuccessfulInput() throws {
        let url = try XCTUnwrap(URL(string: "test.com"))
        let response = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: HTTPURLResponse.StatusCode.badRequest,
            httpVersion: "2.0",
            headerFields: nil
        ))
        let input = (data: Data(), response: response)
        let urlFailure = expectation(description: "fails with url error")
        Just(input)
            .tryHTTPMap()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        switch error {
                        case NetworkService.Failure.http:
                            urlFailure.fulfill()
                        default:
                            XCTFail("Incorrect error received")
                        }
                    case .finished:
                        XCTFail("Unexpected successful finish")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Unexpected successful output")
                }
            )
            .store(in: &cancellables)
        wait(for: [urlFailure], timeout: 0.1)
    }

    func testSuccessfulInput() throws {
        let url = try XCTUnwrap(URL(string: "test.com"))
        let response = try XCTUnwrap(HTTPURLResponse(
            url: url,
            statusCode: HTTPURLResponse.StatusCode.ok,
            httpVersion: "2.0",
            headerFields: nil
        ))
        let input = (data: Data(), response: response)
        let successfulValueReceived = expectation(description: "Outputs a successful response")
        let successfulCompletion = expectation(description: "Finishes with a successful completion")
        Just(input)
            .tryHTTPMap()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure:
                        XCTFail("Unexpected failure completion")
                    case .finished:
                        successfulCompletion.fulfill()
                    }
                },
                receiveValue: { _ in
                    successfulValueReceived.fulfill()
                }
            )
            .store(in: &cancellables)
        wait(for: [successfulValueReceived, successfulCompletion], timeout: 0.1)
    }

    // MARK: Publisher where Failure: Error, Failure == NetworkService.Failure

    func testUnknownNSError() throws {
        struct TestError: Error {}
        let input = TestError()
        let inputWrappedAsNetworkServiceFailure = expectation(
            description: "Maps input NSError to a NetworkService.Failure"
        )
        Combine.Fail<Void, Error>(error: input)
            .mapToNetworkError()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(failure):
                        switch failure {
                        case let .cocoa(error):
                            assert(error == (input as NSError), "Received error matches expected from input")
                            inputWrappedAsNetworkServiceFailure.fulfill()
                        default:
                            XCTFail("Incorrect failure received")
                        }
                    case .finished:
                        XCTFail("Unexpected successful completion received")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Unexpected successful value received")
                }
            )
            .store(in: &cancellables)
        wait(for: [inputWrappedAsNetworkServiceFailure], timeout: 0.1)
    }

    func testNetworkServiceFailure() throws {
        let url = try XCTUnwrap(URL(string: "test.com"))
        let response = URLResponse(
            url: url,
            mimeType: "",
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let input = NetworkService.Failure.url(response)
        let sameOutputAsInput = expectation(description: "Outputs same error as input")
        Combine.Fail<Void, Error>(error: input)
            .mapToNetworkError()
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(failure):
                        assert(failure == input, "Received error matches expected from input")
                        sameOutputAsInput.fulfill()
                    case .finished:
                        XCTFail("Unexpected successful completion received")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Unexpected successful value received")
                }
            )
            .store(in: &cancellables)
        wait(for: [sameOutputAsInput], timeout: 0.1)
    }

    static var allTests = [
        ("testInvalidInput", testInvalidInput),
        ("testUnsuccessfulInput", testUnsuccessfulInput),
        ("testSuccessfulInput", testSuccessfulInput),
        ("testUnknownNSError", testUnknownNSError),
        ("testNetworkServiceFailure", testNetworkServiceFailure),
    ]
}
