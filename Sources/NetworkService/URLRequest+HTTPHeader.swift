//
//  URLRequest+Header.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/22/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

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
    public var value: String { self.rawValue }
}

/// Model for HTTP headers
public protocol HTTPHeader {
    var key: String { get }
    var value: String { get }
}
