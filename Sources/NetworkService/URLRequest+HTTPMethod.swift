//
//  URLRequest+HTTPMethod.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/20/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation

extension URLRequest {
    /// Type-safe enumeration of HTTP methods
    public enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }

    /// Getter/Setter wrapper for `httpMethod: String?` using type-safe `HTTPMethod`
    public var method: HTTPMethod? {
        get {
            guard let httpMethod = self.httpMethod else {
                return nil
            }
            return HTTPMethod(rawValue: httpMethod)
        }

        set {
            self.httpMethod = newValue?.rawValue
        }
    }
}
