// TopLevelCodable.swift
// NetworkService
//
// Copyright © 2022 MFB Technologies, Inc. All rights reserved.
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

#if canImport(Combine)
    import Combine
    import Foundation

    /// Associates a default `TopLevelEncoder` type with a given type
    public protocol TopLevelEncodable: Encodable {
        associatedtype AdoptedEncoder: TopLevelEncoder where AdoptedEncoder.Output == Data
        @available(*, unavailable, renamed: "AdoptedEncoder")
        typealias CustomEncoder = Encoder

        /// The default `TopLevelEncoder` for the conforming type
        static var encoder: AdoptedEncoder { get }
    }

    /// Associates a default `TopLevelDecoder` type with a given type
    public protocol TopLevelDecodable: Decodable {
        associatedtype AdoptedDecoder: TopLevelDecoder where AdoptedDecoder.Input == Data

        /// The default `TopLevelDecoder` for the conforming type
        static var decoder: AdoptedDecoder { get }
    }

    /// Convenience protocol for conforming to `TopLevelEncodable` and `TopLevelDecodable`
    public protocol TopLevelCodable: TopLevelEncodable,
        TopLevelDecodable where AdoptedEncoder.Output == AdoptedDecoder.Input {}

    extension Array: TopLevelEncodable where Element: TopLevelEncodable {
        public static var encoder: Element.AdoptedEncoder { Element.encoder }
    }

    extension Array: TopLevelDecodable where Element: TopLevelDecodable {
        public static var decoder: Element.AdoptedDecoder { Element.decoder }
    }

    extension Array: TopLevelCodable where Element: TopLevelCodable {}

    extension Set: TopLevelEncodable where Element: TopLevelEncodable {
        public static var encoder: Element.AdoptedEncoder { Element.encoder }
    }

    extension Set: TopLevelDecodable where Element: TopLevelDecodable {
        public static var decoder: Element.AdoptedDecoder { Element.decoder }
    }

    extension Set: TopLevelCodable where Element: TopLevelCodable {}

#endif
