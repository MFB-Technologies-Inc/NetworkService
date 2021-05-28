//
//  File.swift
//  
//
//  Created by Andrew Roan on 5/20/21.
//

import Foundation

extension NetworkServiceClient {
    /// Default implementation of `getSession` that returns the `shared` instance
    public func getSession() -> URLSession {
        URLSession.shared
    }
}
