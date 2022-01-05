// URLRequest+HTTPHeader.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension URLRequest {
    /// Add HTTP header values to a URLRequest with type safety, avoiding the use of raw strings
    /// - Parameter header: The HTTP header to be added
    public mutating func addValue(_ header: HTTPHeader) {
        addValue(header.value, forHTTPHeaderField: header.key)
    }

    /// Enumeration of all available HTTP ContentTypes
    public enum ContentType: String {
        public static let key = "Content-Type"

        case applicationJSON = "application/json"
        case textJSON = "text/json"
        case textPlain = "text/plain"
    }
}

extension URLRequest.ContentType: HTTPHeader {
    public var key: String { Self.key }
    public var value: String { rawValue }
}

/// Model for HTTP headers
public protocol HTTPHeader {
    var key: String { get }
    var value: String { get }
}
