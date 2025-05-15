//
//  KeyStore.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Entities

/// A Keystore offers a key-based value persistence source of data.
open class KeyStore: @unchecked Sendable {
    private let _get: @Sendable (_ key: Key) throws -> Data?
    private let _set: @Sendable (_ data: Data, _ key: Key) throws -> Void
    private let _delete: @Sendable (_ key: Key) -> Void
    private let _clear: @Sendable () -> Void

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        get: @escaping @Sendable (_ key: Key) throws -> Data?,
        set: @escaping @Sendable (_ data: Data,
                                  _ key: Key) throws -> Void,
        delete: @escaping @Sendable (_ key: Key) -> Void,
        clear: @escaping @Sendable () -> Void
    ) {
        self._get = get
        self._set = set
        self._delete = delete
        self._clear = clear
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Retrieves the associated value identified by the given key.
    ///  - parameters:
    ///      - key: The key used to identify the stored value.
    ///  - returns: If a value already exists in the store, returns that value. Returns `nil` otherwise.
    open func get<Item: Codable & Sendable>(for key: Key) throws -> Item? {
        guard let data = try _get(key) else { return nil }
        return try decoder.decode(Item.self, from: data)
    }

    /// Stores the given value identified by the given key.
    ///  - parameters:
    ///      - value: The value to store. If `nil`, removes any stored value.
    ///      - key: The key to identify this value by.
    /// - important: If the given `value` is an `Optional` and its value is `nil`, calling this function effectively removes the stored value.
    open func set<Item: Codable & Sendable>(_ value: Item, for key: Key) throws {
        if let optional = value as? AnyOptional, optional.isNil {
            return delete(key: key)
        }
        try _set(encoder.encode(value), key)
    }

    /// Deletes any stored value identified by the given key
    ///
    /// - parameters:
    ///     - key: The key used to identify the stored value
    public func delete(key: Key) {
        _delete(key)
    }

    /// Deletes all stored values.
    public func clear() {
        _clear()
    }
}

public extension KeyStore {
    /// Identifies a KeyStore value
    struct Key: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Sendable, Equatable {

        /// The identifier for the resource
        public let identifier: String

        /// The entity responsible for this resource. Only relevant for keychain-related items
        let provider: String

        init(identifier: String, provider: String) {
            self.identifier = identifier
            self.provider = provider
        }

        /// Instantiates a key for generic data (equivalent to calling `Self.data(<value>)`)
        public init(stringLiteral value: String) {
            self.init(identifier: value, provider: "data-\(value)")
        }

        /// Instantiates a key for generic data (equivalent to calling `Self.data(<interpolated_value>)`)
        public init(stringInterpolation: String) {
            self.init(stringLiteral: stringInterpolation)
        }

        public static func == (lhs: Key, rhs: Key) -> Bool {
            lhs.identifier == rhs.identifier && lhs.provider == rhs.provider
        }

        /// Stores a password identified by the given identifier.
        public static func password(_ id: String, provider: String) -> Key { .init(identifier: id, provider: provider) }
        /// Stores any sort of data identified by the given identifier
        public static func data(_ id: String) -> Key { .init(identifier: id, provider: "data-\(id)") }
    }
}

public extension KeyStore {
    /// Returns a cached version of this keystore, with the given cache duration & time provider.
    func cached(duration: TimeInterval, dateProvider: DateProvider) -> CachingKeyStore {
        .init(
            encoder: encoder,
            decoder: decoder,
            cacheLifeDuration: duration,
            dateProvider: dateProvider,
            get: _get,
            set: _set,
            delete: _delete,
            clear: _clear
        )
    }
}
