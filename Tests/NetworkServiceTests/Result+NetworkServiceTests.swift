// Result+NetworkServiceTests.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Combine)
    import Combine
    import Foundation
    import NetworkService
    import XCTest

    final class ResultNetworkServiceTests: XCTestCase {
        // MARK: Publisher where Output == URLSession.DataTaskPublisher.Output

        func testInvalidInput() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = URLResponse(
                url: url,
                mimeType: "",
                expectedContentLength: 0,
                textEncodingName: nil
            )
            let input = (Data(), response)
            let result = Result<(Data, URLResponse), any Error>.success(input)
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssertEqual(error, NetworkService.Failure.urlResponse(response))
        }

        func testUnsuccessfulInput() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: HTTPURLResponse.StatusCode.badRequest,
                httpVersion: "2.0",
                headerFields: nil
            ))
            let input = (Data(), response)
            let result = Result<(Data, URLResponse), any Error>.success(input)
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssertEqual(error, NetworkService.Failure.httpResponse(response))
        }

        func testSuccessfulInput() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: HTTPURLResponse.StatusCode.ok,
                httpVersion: "2.0",
                headerFields: nil
            ))
            let input = (Data(), response)
            let result = Result<(Data, URLResponse), any Error>.success(input)
                .httpMap()
            XCTAssertEqual(try result.get(), input.0)
        }

        // MARK: Publisher where Failure: Error, Failure == NetworkService.Failure

        func testUnknownNSError() async throws {
            let result = Result<(Data, URLResponse), any Error>
                .failure(NetworkService.Failure.urlError(URLError(.badServerResponse)))
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssertEqual(error, NetworkService.Failure.urlError(URLError(.badServerResponse)))
        }

        func testNetworkServiceFailure() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = URLResponse(
                url: url,
                mimeType: "",
                expectedContentLength: 0,
                textEncodingName: nil
            )
            let result = Result<(Data, URLResponse), any Error>.failure(NetworkService.Failure.urlResponse(response))
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssertEqual(error, NetworkService.Failure.urlResponse(response))
        }

        static var allTests = [
            ("testInvalidInput", testInvalidInput),
            ("testUnsuccessfulInput", testUnsuccessfulInput),
            ("testSuccessfulInput", testSuccessfulInput),
            ("testUnknownNSError", testUnknownNSError),
            ("testNetworkServiceFailure", testNetworkServiceFailure),
        ]
    }
#endif
