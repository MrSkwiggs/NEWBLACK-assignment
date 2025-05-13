//
//  Query.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation

public protocol QueryFilterable: Sendable, Equatable, Codable {}

extension String: QueryFilterable {}
extension Int: QueryFilterable {}
extension Double: QueryFilterable {}
extension Bool: QueryFilterable {}

/// <#Description#>
public struct Query<Item: DTO>: Sendable, Encodable {
    let filter: Filter
    let options: [Option]


    /// Creates a query with the given filter and options.
    /// - Parameters:
    ///   - filter: A filter to apply to the query.
    ///   - options: An array of options to apply to the query.
    public init(filter: Filter, options: [Option]) {
        self.filter = filter
        self.options = options
    }

    /// Creates a query with the given filters and options.
    /// - Parameters:
    ///   - filters: An array of filters to apply to the query. The filters are combined using a logical AND operation.
    ///   - options: An array of options to apply to the query.
    public init(filters: Filter..., options: [Option]) {
        self.filter = .and(filters)
        self.options = options
    }

    enum CodingKeys: String, CodingKey {
        case filter = "query"
        case options
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.filter, forKey: .filter)

        var optionsContainer = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .options)
        for option in options {
            try option.encode(to: &optionsContainer)
        }
    }
}

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

        /// The absence of a filter.
        public static var empty: Filter { .and([]) }

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

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKey.self)
            switch self {
            case .contains(_, let values):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: codingKey)
                try nested.encode(values.map { AnyEncodable($0) }, forKey: operatorKey)

            case .equals(_, let value):
                try container.encode(AnyEncodable(value), forKey: codingKey)

            case .greaterThan(_, let value, _):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: codingKey)
                try nested.encode(AnyEncodable(value), forKey: operatorKey)
            case .lessThan(_, let value, _):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: codingKey)
                try nested.encode(AnyEncodable(value), forKey: operatorKey)
            case .and(let filters):
                var nested = container.nestedUnkeyedContainer(forKey: operatorKey)
                for filter in filters {
                    try nested.encode(filter)
                }
            case .or(let filters):
                var nested = container.nestedUnkeyedContainer(forKey: operatorKey)
                for filter in filters {
                    try nested.encode(filter)
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

        func encode(to container: inout KeyedEncodingContainer<DynamicCodingKey>) throws {
            switch self {
            case .select(let fields):
                var nested = container.nestedUnkeyedContainer(forKey: "select")
                for field in fields {
                    try nested.encode(field.rawValue)
                }

            case .pagination(let pagination):
                try pagination.encode(to: &container)

            case .populate(let fields):
                var nested = container.nestedUnkeyedContainer(forKey: "populate")
                for field in fields {
                    try nested.encode(field.rawValue)
                }
            }
        }
    }
}

public extension Query.Option {
    struct Pagination: Sendable, Equatable, Hashable {
        let page: Int
        let pageSize: Int

        func encode(to container: inout KeyedEncodingContainer<DynamicCodingKey>) throws {
            try container.encode(page, forKey: "page")
            try container.encode(pageSize, forKey: "limit")
        }
    }
}
