//
//  NetworkServiceTests+Get.swift
//  NetworkServiceTests
//
//  Created by Andrew Roan on 4/22/21.
//  Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import Combine
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import NetworkService

extension NetworkServiceTests {

    // MARK: Success
    func testGetSuccess() throws {
        let url = try destinationURL()
        let data = (try? responseBodyEncoded()) ?? Data()
        stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
            return HTTPStubsResponse(
                data: data,
                statusCode: Int32(HTTPURLResponse.StatusCode.ok),
                headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
            )
        }

        let successfulResponse = expectation(description: "Receive a successful response")
        let finished = expectation(description: "Publisher finished")

        let service = NetworkService()
        let publisher: AnyPublisher<Lyric, Failure> = service.get(url)
        publisher.receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
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
            .store(in: &self.cancellables)
        wait(for: [successfulResponse, finished])
    }

    // MARK: Failure
    func testGetFailure() throws {
        let data = (try? responseBodyEncoded()) ?? Data()
        stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
            return HTTPStubsResponse(
                data: data,
                statusCode: Int32(HTTPURLResponse.StatusCode.badRequest),
                headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
            )
        }

        let errorResponse = expectation(description: "Responded with error as expected")

        let service = NetworkService()
        let url = try destinationURL()
        let publisher: AnyPublisher<Lyric, Failure> = service.get(url)
        publisher.receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        switch error {
                        case .http(let response):
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
            .store(in: &self.cancellables)
        wait(for: [errorResponse])
    }
}
