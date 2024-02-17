// NetworkTestCase.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation
import OHHTTPStubs
import XCTest

class NetworkTestCase: XCTestCase {
    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }
}
