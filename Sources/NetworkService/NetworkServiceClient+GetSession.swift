//
//  NetworkServiceClient+GetSession.swift
//  NetworkService
//
//  Created by Andrew Roan on 5/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
//

import Foundation

extension NetworkServiceClient {
    /// Default implementation of `getSession` that returns the `shared` instance
    public func getSession() -> URLSession {
        URLSession.shared
    }
}
