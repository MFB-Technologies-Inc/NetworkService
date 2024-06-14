// NetworkServiceError.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import HTTPTypes

/// `NetworkService`'s error domain
public enum NetworkServiceError: Error, Hashable, Sendable {
    case urlResponse(URLResponse)
    case httpResponse(HTTPResponse)
    case urlError(URLError)
    case unknown(NSError)
    case invalidRequest(HTTPRequest)

    @inlinable
    public var localizedDescription: String {
        switch self {
        case let .urlResponse(urlResponse):
            urlResponse.description
        case let .httpResponse(httpResponse):
            httpResponse.status.reasonPhrase
        case let .urlError(urlError):
            urlError.localizedDescription
        case let .unknown(nsError):
            nsError.localizedDescription
        case let .invalidRequest(request):
            "Failed to form a URLRequest from the HTTPRequest: \(request.debugDescription)"
        }
    }
}
