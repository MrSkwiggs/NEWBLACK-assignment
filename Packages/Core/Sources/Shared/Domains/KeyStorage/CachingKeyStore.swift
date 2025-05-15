//
//  CachingKeyStore.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Entities

/// A Keystore that only keeps its data for a limited time.
///
/// If a cached value is accessed after it has expired, it will be deleted and return `nil`.
open class CachingKeyStore: KeyStore, @unchecked Sendable {

    private let cacheLifeDuration: TimeInterval
    private let dateProvider: DateProvider

    public init(
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        cacheLifeDuration: TimeInterval,
        dateProvider: DateProvider,
        get: @escaping @Sendable (KeyStore.Key) throws -> Data?,
        set: @escaping @Sendable (Data, KeyStore.Key) throws -> Void,
        delete: @escaping @Sendable (KeyStore.Key) -> Void,
        clear: @escaping @Sendable () -> Void
    ) {
        self.cacheLifeDuration = cacheLifeDuration
        self.dateProvider = dateProvider
        super.init(encoder: encoder, decoder: decoder, get: get, set: set, delete: delete, clear: clear)
    }

    /// Retrieves the associated value identified by the given key.
    ///
    /// - parameters:
    ///     - key: The key used to identify the stored value.
    /// - returns: If a value exists in the store and it has not yet expired, returns that value. If the value has expired, it is first deleted, and then this function returns `nil`.
    public override func get<Item: Codable & Sendable>(for key: KeyStore.Key) throws -> Item? {
        guard let cachedValue: Cached<Item> = try super.get(for: key) else { return nil }
        guard cachedValue.dateOfExpiry > dateProvider.now() else {
            super.delete(key: key)
            return nil
        }
        return cachedValue.value
    }

    public override func set<Item: Codable & Sendable>(_ value: Item, for key: KeyStore.Key) throws {
        if let optional = value as? AnyOptional, optional.isNil {
            return delete(key: key)
        }
        try super.set(Cached(dateOfExpiry: dateProvider.date(after: cacheLifeDuration), value: value), for: key)
    }
}

private extension CachingKeyStore {
    struct Cached<Value: Codable & Sendable>: Codable, Sendable {
        let dateOfExpiry: Date
        let value: Value
    }
}
