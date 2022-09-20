//
//  File.swift
//  
//
//  Created by andrew on 9/20/22.
//

import Foundation

extension URLRequest {
    static func service<S>(url: URL, body: Data? = nil, headers: S, method: HTTPMethod) -> Self where S: Sequence, S.Element == HTTPHeader {
        var request = URLRequest(url: url)
        request.httpBody = body
        request.addValues(headers)
        request.method = method
        return request
    }
}
