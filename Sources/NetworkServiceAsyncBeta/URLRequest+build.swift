// URLRequest+build.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension URLRequest {
    static func build<S>(url: URL, body: Data? = nil, headers: S, method: HTTPMethod) -> Self where S: Sequence,
        S.Element == HTTPHeader
    {
        var request = URLRequest(url: url)
        request.httpBody = body
        request.addValues(headers)
        request.method = method
        return request
    }
}
