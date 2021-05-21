//
//  CustomCodable.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/23/21.
//  Copyright © 2021 MFB Technologies. All rights reserved.
//

import Foundation
import Combine

/// Associates a default `TopLevelEncoder` type with a given type
public protocol CustomEncodable: Encodable {
    associatedtype CustomEncoder: TopLevelEncoder

    /// The default `TopLevelEncoder` for the conforming type
    static var encoder: CustomEncoder { get }
}

/// Associates a default `TopLevelDecoder` type with a given type
public protocol CustomDecodable: Decodable {
    associatedtype CustomDecoder: TopLevelDecoder

    /// The default `TopLevelDecoder` for the conforming type
    static var decoder: CustomDecoder { get }
}

/// Convenience protocol for conforming to `CustomEncodable` and `CustomDecodable`
public protocol CustomCodable: CustomEncodable, CustomDecodable where CustomEncoder.Output == CustomDecoder.Input {}
