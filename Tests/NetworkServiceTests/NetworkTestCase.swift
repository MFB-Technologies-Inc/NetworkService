// NetworkTestCase.swift
// NetworkService
//
// Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation
import OHHTTPStubs
import XCTest

class NetworkTestCase: AsyncTestCase {
    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }

    func wait(for expectations: [XCTestExpectation]) {
        wait(for: expectations, timeout: 1)
    }
}
