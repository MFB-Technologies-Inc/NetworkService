// NetworkServiceTests+Delete.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Combine)
    import Combine
    import Foundation
    import NetworkService
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    extension NetworkServiceTests {
        // MARK: Success

        func testDeleteSuccess() async throws {
            let url = try destinationURL()
            let data = (try? responseBodyEncoded()) ?? Data()
            stub(condition: isHost(host) && isPath(path) && isMethodDELETE()) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPURLResponse.StatusCode.ok),
                    headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
                )
            }

            let service = NetworkService()
            let result: Result<Lyric, Failure> = await service.delete(url)
            XCTAssertEqual(try result.get(), Lyric.test)
        }

        // MARK: Failure

        func testDeleteFailure() async throws {
            let data = (try? responseBodyEncoded()) ?? Data()
            stub(condition: isHost(host) && isPath(path) && isMethodDELETE()) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPURLResponse.StatusCode.badRequest),
                    headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
                )
            }

            let service = NetworkService()
            let url = try destinationURL()
            let result: Result<Lyric, Failure> = await service.delete(url)
            guard case let .failure(.httpResponse(response)) = result else {
                return XCTFail("Expecting failure but received success.")
            }
            XCTAssert(response.isClientError)
        }
    }
#endif
