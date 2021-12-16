//
//  TopLevelCodable.swift
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
public protocol TopLevelEncodable: Encodable {
    associatedtype Encoder: TopLevelEncoder where Encoder.Output == Data
    @available(*, unavailable, renamed: "Encoder")
    typealias CustomEncoder = Encoder

    /// The default `TopLevelEncoder` for the conforming type
    static var encoder: Encoder { get }
}

@available(*, unavailable, renamed: "TopLevelEncodable")
public typealias CustomEncodable = TopLevelEncodable

/// Associates a default `TopLevelDecoder` type with a given type
public protocol TopLevelDecodable: Decodable {
    associatedtype Decoder: TopLevelDecoder where Decoder.Input == Data
    @available(*, unavailable, renamed: "Encoder")
    typealias CustomDecoder = Decoder

    /// The default `TopLevelDecoder` for the conforming type
    static var decoder: Decoder { get }
}

@available(*, unavailable, renamed: "TopLevelDecodable")
public typealias CustomDecodable = TopLevelDecodable

/// Convenience protocol for conforming to `TopLevelEncodable` and `TopLevelDecodable`
public protocol TopLevelCodable: TopLevelEncodable, TopLevelDecodable where Encoder.Output == Decoder.Input {}

@available(*, unavailable, renamed: "TopLevelCodable")
public typealias CustomCodable = TopLevelCodable

extension Array: TopLevelEncodable where Element: TopLevelEncodable {
    public static var encoder: Element.Encoder { Element.encoder }
}

extension Array: TopLevelDecodable where Element: TopLevelDecodable {
    public static var decoder: Element.Decoder { Element.decoder }
}

extension Array: TopLevelCodable where Element: TopLevelCodable {}

extension Set: TopLevelEncodable where Element: TopLevelEncodable {
    public static var encoder: Element.Encoder { Element.encoder }
}

extension Set: TopLevelDecodable where Element: TopLevelDecodable {
    public static var decoder: Element.Decoder { Element.decoder }
}

extension Set: TopLevelCodable where Element: TopLevelCodable {}
