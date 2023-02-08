// XCTestManifests.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(NetworkServiceTests.allTests),
            testCase(PublisherNetworkServicesTests.allTests),
        ]
    }
#endif
