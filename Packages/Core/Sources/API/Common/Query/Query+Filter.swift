//
//  Query+Filter.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public extension Query {
    /// A filter to apply to a query.
    /// 
    /// The filter can be used to filter items based on their fields and values.
    /// It supports various operations such as equality, containment, and range filtering.
    /// It can also be combined using logical operators like AND and OR.
    enum Filter: Sendable, Encodable {
        /// A filter that checks if a field is equal to a value.
        case equals(field: Item.Field, value: any QueryFilterable)
        /// A filter that checks if a field is any of the specified values.
        case contains(field: Item.Field, values: [any QueryFilterable])
        /// A filter that checks if a field is less than or equal to the given value.
        case lessThan(field: Item.Field, value: any QueryFilterable, inclusive: Bool = false)
        /// A filter that checks if a field is greater than or equal to the given value.
        case greaterThan(field: Item.Field, value: any QueryFilterable, inclusive: Bool = false)

        /// A filter that combines multiple filters using the logical AND operator.
        case and([Filter])
        /// A filter that combines multiple filters using the logical OR operator.
        case or([Filter])

        /// A filter that combines multiple filters for a specific field.
        case compound(field: Item.Field, filters: [Filter])

        /// Creates a filter that checks if a field is contained in the given range.
        static func range<T: Comparable & QueryComparable>(field: Item.Field, range: Range<T>) -> Filter {
            .compound(field: field, filters: [
                .lessThan(field: field, value: range.upperBound, inclusive: false),
                .greaterThan(field: field, value: range.lowerBound, inclusive: true)
            ])
        }

        /// Creates a filter that checks if a field is contained in the given closed range.
        static func range<T: Comparable & QueryComparable>(field: Item.Field, range: ClosedRange<T>) -> Filter {
            .compound(field: field, filters: [
                .lessThan(field: field, value: range.upperBound, inclusive: true),
                .greaterThan(field: field, value: range.lowerBound, inclusive: true)
            ])
        }

        /// The absence of a filter.
        public static var empty: Filter { .and([]) }

        /// Whether the filter is empty.
        public var isEmpty: Bool {
            switch self {
            case .and(let filters):
                return filters.isEmpty
            case .or(let filters):
                return filters.isEmpty
            default:
                return false
            }
        }

        var value: AnyEncodable? {
            switch self {
            case .equals(_, let value):
                return AnyEncodable(value)
            case .contains(_, let values):
                return AnyEncodable(values.map { AnyEncodable($0) })
            case .lessThan(_, let value, _):
                return AnyEncodable(value)
            case .greaterThan(_, let value, _):
                return AnyEncodable(value)
            case .and, .or, .compound:
                return nil
            }
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
            case .compound(let field, _):
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
            case .compound(let field, _):
                .init(field)
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
            case .compound(_, let filters):
                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: operatorKey)
                for filter in filters {
                    try nested.encodeIfPresent(filter.value, forKey: filter.operatorKey)
                }
            }
        }
    }
}
