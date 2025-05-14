//
//  AnyEncodable.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type-erased wrapper for `Encodable` values. This allows you to store any
/// `Encodable` type in a single collection or pass it around without knowing
/// its concrete type.
public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    public init<T: Encodable>(_ value: T) {
        self._encode = { encoder in
            // Dispatching to single value container is needed to retain the
            // original type & properly defer encoding through the encoder.
            var container = encoder.singleValueContainer()
            try container.encode(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
