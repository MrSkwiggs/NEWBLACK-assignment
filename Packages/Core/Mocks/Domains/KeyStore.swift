//
//  KeyStore.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Shared

import Foundation

public extension KeyStore {
    /// A Keystore where all requirements are optional. Does not do anything unless given specific instructions.
    ///
    /// This implementation is handy for unit tests or other scenarios where you only need a specific subset of features.
    static func mock(
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        get: @escaping @Sendable (KeyStore.Key) -> Data? = { _ in nil },
        set: @escaping @Sendable (Data, Key) -> Void = { _, _ in },
        delete: @escaping @Sendable (Key) -> Void = { _ in },
        clear: @escaping @Sendable () -> Void = {}
    ) -> KeyStore {
        .init(
            encoder: encoder,
            decoder: decoder,
            get: get,
            set: set,
            delete: delete,
            clear: clear
        )
    }
}
