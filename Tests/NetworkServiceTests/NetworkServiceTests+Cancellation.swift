// NetworkServiceTests+Cancellation.swift
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
    import OHHTTPStubs
    import OHHTTPStubsSwift
    import XCTest

    extension NetworkServiceTests {
        /// Manually verified to cancel the `URLSessionDataTask` from the task continuation handler's body when
        /// `Task.isCancelled` is checked.
        func testImmediateCancellation() async throws {
            let url = try destinationURL()
            let data = try responseBodyEncoded()
            stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
                HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPURLResponse.StatusCode.ok),
                    headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
                )
            }

            let resultTask = Task {
                let service = NetworkService()
                let result: Result<Lyric, NetworkService.Failure> = await service.get(url)
                return result
            }

            resultTask.cancel()

            let result = await resultTask.value
            guard case let .failure(.urlError(urlError)) = result else {
                XCTFail("Not expecting success")
                return
            }
            XCTAssertEqual(urlError.code, URLError.Code.cancelled)
        }

        /// Manually verified to cancel the `URLSessionDataTask` from the task cancellation handler's `onCancel`
        /// closure.
        @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
        func testDelayedCancellation() async throws {
            let url = try destinationURL()
            let data = try responseBodyEncoded()
            stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
                Thread.sleep(forTimeInterval: 0.5)
                return HTTPStubsResponse(
                    data: data,
                    statusCode: Int32(HTTPURLResponse.StatusCode.ok),
                    headers: [URLRequest.ContentType.key: URLRequest.ContentType.applicationJSON.value]
                )
            }

            let resultTask = Task {
                let service = NetworkService()
                let result: Result<Lyric, NetworkService.Failure> = await service.get(url)
                return result
            }
            try await Task.sleep(for: .milliseconds(250))

            resultTask.cancel()

            let result = await resultTask.value
            guard case let .failure(.urlError(urlError)) = result else {
                XCTFail("Not expecting success")
                return
            }
            XCTAssertEqual(urlError.code, URLError.Code.cancelled)
        }
    }
#endif
