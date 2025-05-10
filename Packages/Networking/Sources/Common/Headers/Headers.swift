//
//  Headers.swift
//  Networking
//

import Foundation

/// A type that represents HTTP headers.
@dynamicMemberLookup
public struct Headers: Sendable, Codable, ExpressibleByDictionaryLiteral, Equatable, Hashable, Sequence {
    public typealias Element = Dictionary<String, String>.Element
    public typealias Iterator = Dictionary<String, String>.Iterator

    public typealias Value = String

    public init(dictionaryLiteral elements: (Key, String)...) {
        all = elements.reduce(into: [:], { partialResult, keyVal in
            partialResult[keyVal.0.rawValue] = keyVal.1
        })
    }

    /// All headers as a dictionary.
    public var all: [String: String] = [:]

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.all = try container.decode([String : String].self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(all)
    }

    /// Gets a header value for a given key.
    public subscript(dynamicMember dynamicMember: KeyPath<Headers.Key.Type, Headers.Key>) -> String? {
        self.all[Key.self[keyPath: dynamicMember].rawValue]
    }
    
    public func makeIterator() -> Dictionary<String, String>.Iterator {
        all.makeIterator()
    }

    /// Gets a header value for a given key.
    public func get<Value: RawRepresentable>(_ key: Key) -> Value? where Value.RawValue == String {
        all[key.rawValue].map { .init(rawValue: $0) } ?? nil
    }

    /// Gets a header value for a given key.
    public func get(_ key: Key) -> String? {
        all[key.rawValue].map { $0 } ?? nil
    }

    /// Sets a header value for a given key.
    public mutating func set<Value: RawRepresentable>(_ value: Value?, for key: Key) where Value.RawValue == String {
        all[key.rawValue] = value?.rawValue
    }

    /// Sets a header value for a given key.
    public mutating func set(_ value: String?, for key: Key) {
        all[key.rawValue] = value
    }

    /// Merges another set of headers into this one. Previous values will be replaced with new ones.
    public static func + (lhs: Headers, rhs: Headers) -> Headers {
        var lhs = lhs
        lhs.all.merge(rhs.all) { left, right in
            right
        }

        return lhs
    }
}

public extension Headers {
    struct Key: Sendable, Hashable, RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Codable {
        public typealias RawValue = String
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        public static let contentType: Key = "Content-Type"
        public static let accept: Key = "Accept"
        public static let userAgent: Key = "User-Agent"
        public static let authorization: Key = "Authorization"
        public static let cookie: Key = "Cookie"
    }
}
