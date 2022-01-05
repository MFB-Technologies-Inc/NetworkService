// NetworkServiceClient+GetSession.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import Foundation

extension NetworkServiceClient {
    /// Default implementation of `getSession` that returns the `shared` instance
    public func getSession() -> URLSession {
        URLSession.shared
    }
}
