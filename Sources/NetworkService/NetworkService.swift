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
public final class NetworkService: Sendable {
    /// `NetworkService`'s error domain
    public enum Failure: Error, Hashable, Sendable {
        case urlResponse(URLResponse)
        case httpResponse(HTTPURLResponse)
        case urlError(URLError)
        case unknown(NSError)

        public var localizedDescription: String {
            switch self {
            case let .urlResponse(urlResponse):
                return urlResponse.description
            case let .httpResponse(httpResponse):
                return httpResponse.description
            case let .urlError(urlError):
                return urlError.localizedDescription
            case let .unknown(nsError):
                return nsError.localizedDescription
            }
        }
    }

    public init() {}
}

// MARK: NetworkService+NetworkServiceClient

extension NetworkService: NetworkServiceClient {}
