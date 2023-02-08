// NetworkService.swift
// NetworkService
//
// Copyright © 2023 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation

/// Provides methods for making network requests and processing the resulting responses
public final class NetworkService {
    /// `NetworkService`'s error domain
    public enum Failure: Error, Hashable {
        case url(URLResponse)
        case http(HTTPURLResponse)
        case cocoa(NSError)
    }

    public init() {}
}

// MARK: NetworkService+NetworkServiceClient

extension NetworkService: NetworkServiceClient {}
