//
//  CustomCodable.swift
//  NetworkService
//
//  Created by Andrew Roan on 4/23/21.
//  Copyright © 2021 MFB Technologies, Inc. All rights reserved.
//
//  This source code is licensed under the MIT license found in the
//  LICENSE file in the root directory of this source tree.
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

extension Array: CustomEncodable where Element: CustomEncodable {
    public static var encoder: Element.CustomEncoder { Element.encoder }
}

extension Array: CustomDecodable where Element: CustomDecodable {
    public static var decoder: Element.CustomDecoder { Element.decoder }
}

extension Array: CustomCodable where Element: CustomCodable {}

extension Set: CustomEncodable where Element: CustomEncodable {
    public static var encoder: Element.CustomEncoder { Element.encoder }
}

extension Set: CustomDecodable where Element: CustomDecodable {
    public static var decoder: Element.CustomDecoder { Element.decoder }
}

extension Set: CustomCodable where Element: CustomCodable {}
