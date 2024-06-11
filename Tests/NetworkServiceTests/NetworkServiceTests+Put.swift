// NetworkServiceTests+Put.swift
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

        func testPutSuccess() async throws {
            let url = try destinationURL()
            let data = try responseBodyEncoded()
            stub(
                condition: isHost(host)
                    && isPath(path)
                    && isMethodPUT()
                    && hasBody(data)
            ) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPResponse.Status.ok.code),
                    headers: HTTPFields([HTTPField(name: .contentType, value: "application/json")]).asDictionary()
                )
            }

            let service = NetworkServiceClient()
            let result: Result<Lyric, Failure> = await service.put(data, to: url)
            XCTAssertNoDifference(try result.get(), Lyric.test)
        }

        // MARK: Failure

        func testPutFailure() async throws {
            let data = try responseBodyEncoded()
            stub(
                condition: isHost(host)
                    && isPath(path)
                    && isMethodPUT()
                    && hasBody(data)
            ) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPResponse.Status.badRequest.code),
                    headers: HTTPFields([HTTPField(name: .contentType, value: "application/json")]).asDictionary()
                )
            }

            let service = NetworkServiceClient()
            let url = try destinationURL()
            let result: Result<Lyric, Failure> = await service.put(data, to: url)
            guard case let .failure(.httpResponse(response)) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssert(response.status.kind == .clientError)
        }
    }
#endif
