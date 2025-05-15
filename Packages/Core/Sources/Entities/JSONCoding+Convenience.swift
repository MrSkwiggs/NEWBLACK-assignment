//
//  MissingCodingKey.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public extension KeyedDecodingContainer {
    /// Return-type aware, decodes a value of the given type for the given key.
    ///
    /// - note: Equivalent to calling `decode(Value.self, forKey: <key>)`.
    ///
    /// - parameters:
    ///     - type: The type of value to decode.
    ///     - key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    func decode<Value: Decodable>(type: Value.Type = Value.self, _ key: Key) throws -> Value {
        try decode(type, forKey: key)
    }

    /// Return-type aware, decodes a value of the given type for the given key, if present.
    ///
    /// - note: Equivalent to calling `decodeIfPresent(Value.self, forKey: <key>)`.
    ///
    /// - parameters:
    ///     - type: The type of value to decode.
    ///     - key: The key that the decoded value is associated with.
    /// - returns: A decoded value of the requested type, or nil if the Decoder does not have an entry associated with the given key, or if the value is a null value.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    func decodeIfPresent<Value: Decodable>(type: Value.Type = Value.self, _ key: Key) throws -> Value? {
        try decodeIfPresent(type, forKey: key)
    }

    enum MissingCodingKey: CodingKey {
        case missingKey
    }

    /// Return-type aware, decodes a value of the given type for the given keys, if any are present.
    ///
    /// - note: Equivalent to calling `decode(Value.self, forKey: <key>)` for each given key.
    ///
    /// - parameters:
    ///    - type: The type of value to decode.
    ///    - keys: The keys that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given keys and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    func decodeIfPresent<Value: Decodable>(type: Value.Type = Value.self, firstMatch keys: [Key]) throws -> Value? {
        guard !keys.isEmpty else {
            throw DecodingError.keyNotFound(MissingCodingKey.missingKey, .init(codingPath: codingPath, debugDescription: "No keys provided"))
        }

        var result: Value?
        var caughtError: Error?

        for key in keys {
            do {
                result = try decodeIfPresent(key)
                break
            } catch {
                caughtError = error
            }
        }

        if let caughtError, result == nil {
            throw caughtError
        }

        return result
    }

    /// Attempts to decode a collection, skipping any element that fails decoding.
    ///
    /// - parameters:
    ///     - type: The type of the elements in the collection to decode.
    ///     - key: The key that identifies the collection.
    /// - throws: Throws the last caught error if all elements fail decoding.
    /// - note: While flexible, this function prioritizes error handling and data meaningfulness. As such, if all elements fail decoding, the last caught error will be thrown instead of returning an empty array.
    func decodeCollection<Value: Decodable>(type: Value.Type = Value.self, _ key: Key) throws -> [Value] {
        var collection = try nestedUnkeyedContainer(forKey: key)
        var result: [Value] = []
        var caughtError: Error?

        while !collection.isAtEnd {
            do {
                let item: Value = try collection.decodeNext()
                result.append(item)
            } catch {
                caughtError = error
                print("Unable to decode entry for \(Value.self), skipping. Reason: \(error)")
                // Decode an empty element to move to the next value in the collection.
                // This is necessary because decoding an unkeyed container only moves the iterator forward when elements are decoded without throwing.
                let _: Empty = try collection.decodeNext()
            }
        }

        /// Don't return an empty result if errors were thrown
        if result.isEmpty, let caughtError = caughtError {
            throw caughtError
        }

        return result
    }
}


/// Handles type mismatch decoding errors but propagates everything else
///
/// - returns: The decoded value, or `nil` if there was a type mismatch.
/// - throws: Any other error that may occur
fileprivate func ignoreTypeMismatch<Value: Decodable>(
    _ get: @autoclosure () throws -> Value
) throws -> Value? {
    do {
        return try get()
    } catch let error as DecodingError {
        guard case .typeMismatch(_, _) = error else {
            throw error
        }
        return nil
    } catch {
        throw error
    }
}

/// A type conforming to `Decodable` that always succeeds decoding.
///
/// This type is utilized solely for advancing unkeyed containers when manually decoding collections.
fileprivate struct Empty: Decodable {
    init(from decoder: Decoder) throws {}
}

public extension KeyedDecodingContainer {

    /// Attempts to decode a String value from multiple types that String can interpolate from.
    ///
    /// - note: Tries to decode from Int, Double & Bool.
    func decodeString(_ key: Key) throws -> String {
        do {
            return try decode(key)
        } catch {
            if let int: Int = try? decode(key) {
                return "\(int)"
            } else if let double: Double = try ignoreTypeMismatch(decode(key)) {
                return "\(double)"
            } else if let bool: Bool = try ignoreTypeMismatch(decode(key)) {
                return "\(bool)"
            } else {
                throw error
            }
        }
    }

    /// Attempts to decode an Int value from multiple types that can interpolated from.
    ///
    /// - note: Tries to decode from String & Double.
    func decodeInt(_ key: Key) throws -> Int {
        do {
            return try decode(key)
        } catch {
            if let string: String = try ignoreTypeMismatch(decode(key)), let int = Int(string) {
                return int
            } else if let double: Double = try ignoreTypeMismatch(decode(key)) {
                return Int(double)
            } else {
                throw error
            }
        }
    }
}

public extension UnkeyedDecodingContainer {
    /// Return-type aware, decodes a value of the given type.
    ///
    /// - note: Equivalent to calling `decode(Value.self)`.
    ///
    /// - parameters:
    ///     - type: The type of value to decode.
    ///     - key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    mutating func decodeNext<Value: Decodable>(type: Value.Type = Value.self) throws -> Value {
        try decode(type)
    }
}

public extension SingleValueDecodingContainer {
    /// Return-type aware, decodes a value of the given type.
    ///
    /// - note: Equivalent to calling `decode(Value.self)`.
    ///
    /// - parameters:
    ///     - type: The type of value to decode.
    ///     - key: The key that the decoded value is associated with.
    /// - returns: A value of the requested type, if present for the given key and convertible to the requested type.
    /// - throws: `DecodingError.typeMismatch` if the encountered encoded value is not convertible to the requested type.
    /// - throws: `DecodingError.keyNotFound` if self does not have an entry for the given key.
    /// - throws: `DecodingError.valueNotFound` if self has a null entry for the given key.
    func get<Value: Decodable>(type: Value.Type = Value.self) throws -> Value {
        try decode(type)
    }

    /// Attempts to decode a String value from multiple types that String can interpolate from.
    ///
    /// - note: Tries to decode from Int, Double & Bool.
    func decodeString() throws -> String {
        do {
            return try get()
        } catch {
            if let int: Int = try ignoreTypeMismatch(get()) {
                return "\(int)"
            } else if let double: Double = try ignoreTypeMismatch(get()) {
                return "\(double)"
            } else if let bool: Bool = try ignoreTypeMismatch(get()) {
                return "\(bool)"
            } else {
                throw error
            }
        }
    }
}
