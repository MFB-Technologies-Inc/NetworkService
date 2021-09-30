//
//  NetworkTestCase.swift
//  NetworkServiceTests
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation
import Combine
import XCTest
import OHHTTPStubs

class NetworkTestCase: AsyncTestCase {
    override func tearDown() {
        HTTPStubs.removeAllStubs()
    }

    func wait(for expectations: [XCTestExpectation]) {
        wait(for: expectations, timeout: 1)
    }
}
