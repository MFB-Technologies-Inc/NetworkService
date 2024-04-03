// NetworkService.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Combine
import Foundation
import HTTPTypes

/// Provides methods for making network requests and processing the resulting responses
public final class NetworkService {
    public typealias Failure = NetworkServiceError

    public init() {}
}

// MARK: NetworkService+NetworkServiceClient

extension NetworkService: NetworkServiceClient {}
