//
//  NetworkTestCase.swift
//  NetworkServiceTests
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
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
