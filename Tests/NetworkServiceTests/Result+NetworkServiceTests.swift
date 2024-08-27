// Result+NetworkServiceTests.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Combine)
    import Combine
    import CustomDump
    import Foundation
    import HTTPTypes
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
            XCTAssertNil((response as? HTTPURLResponse)?.httpResponse)
        }

        func testUnsuccessfulInput() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: HTTPResponse.Status.badRequest.code,
                httpVersion: "2.0",
                headerFields: nil
            ))
            let input = try (Data(), XCTUnwrap(response.httpResponse))
            let result = Result<(Data, HTTPResponse), any Error>.success(input)
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            try expectNoDifference(error, NetworkService.Failure.httpResponse(XCTUnwrap(response.httpResponse)))
            XCTAssertNoDifference(error, try NetworkServiceError.httpResponse(XCTUnwrap(response.httpResponse)))
        }

        func testSuccessfulInput() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: HTTPResponse.Status.ok.code,
                httpVersion: "2.0",
                headerFields: nil
            ))
            let input = try (Data(), XCTUnwrap(response.httpResponse))
            let result = Result<(Data, HTTPResponse), any Error>.success(input)
                .httpMap()
            try expectNoDifference(result.get(), input.0)
        }

        // MARK: Publisher where Failure: Error, Failure == NetworkServiceError

        func testUnknownNSError() async throws {
            let result = Result<(Data, HTTPResponse), any Error>
                .failure(NetworkServiceError.urlError(URLError(.badServerResponse)))
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            expectNoDifference(error, NetworkService.Failure.urlError(URLError(.badServerResponse)))
            XCTAssertNoDifference(error, NetworkServiceError.urlError(URLError(.badServerResponse)))
        }

        func testNetworkServiceFailure() async throws {
            let url = try XCTUnwrap(URL(string: "test.com"))
            let response = URLResponse(
                url: url,
                mimeType: "",
                expectedContentLength: 0,
                textEncodingName: nil
            )
            let result = Result<(Data, HTTPResponse), any Error>.failure(NetworkServiceError.urlResponse(response))
                .httpMap()
            guard case let .failure(error) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            expectNoDifference(error, NetworkService.Failure.urlResponse(response))
            XCTAssertNoDifference(error, NetworkServiceError.urlResponse(response))
        }
    }
#endif
