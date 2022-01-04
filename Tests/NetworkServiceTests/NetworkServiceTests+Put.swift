// NetworkServiceTests+Put.swift
// NetworkService
//
// Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation
import NetworkService
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

extension NetworkServiceTests {
    // MARK: Success

    func testPutSuccess() throws {
        let url = try destinationURL()
        let data = (try? responseBodyEncoded()) ?? Data()
        stub(
            condition: isHost(host)
                && isPath(path)
                && isMethodPUT()
                && hasBody(data)
        ) { _ in
            HTTPStubsResponse(
                data: data,
                statusCode: Int32(HTTPURLResponse.StatusCode.ok),
                headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
            )
        }

        let successfulResponse = expectation(description: "Receive a successful response")
        let finished = expectation(description: "Publisher finished")

        let service = NetworkService()
        let publisher: AnyPublisher<Lyric, Failure> = service.put(data, to: url)
        publisher.receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        XCTFail("Unexpected failure: \(error)")
                    case .finished:
                        finished.fulfill()
                    }
                },
                receiveValue: { value in
                    assert(value == Lyric.test, "Response body equals expected value")
                    successfulResponse.fulfill()
                }
            )
            .store(in: &cancellables)
        wait(for: [successfulResponse, finished])
    }

    // MARK: Failure

    func testPutFailure() throws {
        let data = (try? responseBodyEncoded()) ?? Data()
        stub(
            condition: isHost(host)
                && isPath(path)
                && isMethodPUT()
                && hasBody(data)
        ) { _ in
            HTTPStubsResponse(
                data: data,
                statusCode: Int32(HTTPURLResponse.StatusCode.badRequest),
                headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
            )
        }

        let errorResponse = expectation(description: "Responded with error as expected")

        let service = NetworkService()
        let url = try destinationURL()
        let publisher: AnyPublisher<Lyric, Failure> = service.put(data, to: url)
        publisher.receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case let .failure(error):
                        switch error {
                        case let .http(response):
                            assert(response.isClientError)
                            errorResponse.fulfill()
                        default:
                            XCTFail("Wrong error type when expecting a client failure: \(error)")
                        }
                    case .finished:
                        XCTFail("Unexpected successful finish")
                    }
                },
                receiveValue: { _ in
                    XCTFail("Unexpected successful response")
                }
            )
            .store(in: &cancellables)
        wait(for: [errorResponse])
    }
}
