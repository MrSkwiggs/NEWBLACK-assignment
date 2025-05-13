//
//  Query.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation

public protocol QueryFilterable: Sendable, Equatable, Comparable, Codable {
    var query: String { get }
}

public struct Query<Item: DTO>: Sendable, Encodable {
    let query: Filter
    let options: [Option]
}

public struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void

    public init<T: Encodable>(_ value: T) {
        self._encode = value.encode(to:)
    }

    public func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

//
//extension DynamicCodingKey {
//    /// Builds a coding key from a DTO's `field`.
//    static func field<T: RawRepresentable>(_ field: T) -> DynamicCodingKey where T.RawValue == String {
//        .init(stringLiteral: "$" + field.rawValue)
//    }
//}
//
public extension Query {
    enum Filter: Sendable, Encodable {
        case equals(field: Item.Field, value: any QueryFilterable)
        case contains(field: Item.Field, values: [any QueryFilterable])
        case lessThan(field: Item.Field, value: any QueryFilterable, inclusive: Bool = false)
        case greaterThan(field: Item.Field, value: any QueryFilterable, inclusive: Bool = false)

        case and([Filter])
        case or([Filter])

        public enum Range<Value: Comparable & Sendable>: Sendable, Equatable {
            case open(Swift.Range<Value>)
            case closed(ClosedRange<Value>)
        }

        var codingKey: DynamicCodingKey {
            return switch self {
            case .equals(let field, _):
                .init(field)
            case .contains(let field, _):
                .init(field)
            case .lessThan(let field, _, _):
                .init(field)
            case .greaterThan(let field, _, _):
                .init(field)

            case .and:
                "$and"
            case .or:
                "$or"
            }
        }

        var operatorKey: DynamicCodingKey {
            return switch self {
            case .equals:
                "$eq"
            case .contains:
                "$in"
            case .lessThan(_, _, let inclusive):
                "$lt\(inclusive ? "e" : "")"
            case .greaterThan(_, _, let inclusive):
                "$gt\(inclusive ? "e" : "")"
            case .and:
                "$and"
            case .or:
                "$or"
            }
        }

//        public var serialised: [String: AnyCodable] {
//            switch self {
//            case .equals(let field, let value):
//                return [field.rawValue: AnyCodable(value)]
//            case .contains(let field, let values):
//                return [field.rawValue: AnyCodable(values)]
//            case .lessThan(let field, let value):
//                return [field.rawValue: AnyCodable(value)]
//            case .greaterThan(let field, let value):
//                return [field.rawValue: AnyCodable(value)]
//            case .and(let filters):
//                return ["$and": AnyCodable(filters.map { $0.serialised })]
//            case .or(let filters):
//                return ["$or": AnyCodable(filters.map { $0.serialised })]
//            }
//        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKey.self)
            switch self {
            case .contains(let field, let values):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: codingKey)
                try nested.encode(values.map { AnyEncodable($0) }, forKey: codingKey)

            case .equals(let field, let value):
                try container.encode(AnyEncodable(value), forKey: codingKey)

            case .greaterThan(let field, let value, _):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: codingKey)
                try nested.encode(AnyEncodable(value), forKey: operatorKey)
            case .lessThan(let field, let value, _):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: codingKey)
                try nested.encode(AnyEncodable(value), forKey: operatorKey)
            case .and(let filters):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: operatorKey)
                for filter in filters {
                    try filter.encode(to: nested.superEncoder(forKey: filter.codingKey))
                }
            case .or(let filters):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: operatorKey)
                for filter in filters {
                    try filter.encode(to: nested.superEncoder(forKey: filter.codingKey))
                }
            }
        }
    }
}

public extension Query {
    enum Option: Sendable {
        case select(fields: Item.Field.AllCases = Item.Field.allCases)
        case pagination(Pagination)
        case populate(fields: Item.Field.AllCases)
    }
}

public extension Query.Option {
    struct Pagination: Sendable, Equatable, Hashable, Encodable {
        let page: Int
        let pageSize: Int
    }
}
