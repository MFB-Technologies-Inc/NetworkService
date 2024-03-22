// HTTPFields+AsDictionary.swift
// NetworkService
//
// Copyright © 2024 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import HTTPTypes

extension HTTPFields {
    func asDictionary() -> [String: String] {
        reduce(into: [:]) { acc, next in
            acc[next.name.description] = next.value
        }
    }
}
