// NetworkServiceTests+Get.swift
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
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    extension NetworkServiceTests {
        // MARK: Success

        func testGetSuccess() async throws {
            let url = try destinationURL()
            let data = try responseBodyEncoded()
            stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPResponse.Status.ok.code),
                    headers: HTTPFields([HTTPField(name: .contentType, value: "application/json")]).asDictionary()
                )
            }

            let service = NetworkService()
            let result: Result<Lyric, Failure> = await service.get(url)
            XCTAssertNoDifference(try result.get(), Lyric.test)
        }

        // MARK: Failure

        func testGetFailure() async throws {
            let data = try responseBodyEncoded()
            stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPResponse.Status.badRequest.code),
                    headers: HTTPFields([HTTPField(name: .contentType, value: "application/json")]).asDictionary()
                )
            }

            let service = NetworkService()
            let url = try destinationURL()
            let result: Result<Lyric, Failure> = await service.get(url)
            guard case let .failure(.httpResponse(response)) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssert(response.status.kind == .clientError)
        }
    }
#endif
