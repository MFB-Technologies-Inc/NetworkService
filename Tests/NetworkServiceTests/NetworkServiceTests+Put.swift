//
//  NetworkServiceTests+Put.swift
//  NetworkServiceTests
//
//  Created by Andrew Roan on 4/22/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation
import Combine
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import NetworkService

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
            return HTTPStubsResponse(
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
    func testPutFailure() throws {
        let data = (try? responseBodyEncoded()) ?? Data()
        stub(
            condition: isHost(host)
                && isPath(path)
                && isMethodPUT()
                && hasBody(data)
        ) { _ in
            return HTTPStubsResponse(
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
