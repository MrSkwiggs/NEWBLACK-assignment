////
////  Query.swift
////  Core
////
////  Created by Dorian on 11/05/2025.
////
//
//import Foundation
//
//public protocol QueryFilterable: Sendable, Equatable, Comparable, Encodable {
//    var query: String { get }
//}
//
//public struct Query<Item: DTO>: Sendable {
//    let query: Filter
//    let options: [Option]
//}
//
//extension DynamicCodingKey {
//    /// Builds a coding key from a DTO's `field`.
//    static func field<T: RawRepresentable>(_ field: T) -> DynamicCodingKey where T.RawValue == String {
//        .init(stringLiteral: "$" + field.rawValue)
//    }
//}
//
//public extension Query {
//    enum Filter: Sendable, Encodable {
//        case equals(field: Item.Field, value: any QueryFilterable)
//        case contains(field: Item.Field, values: [any QueryFilterable])
//        case lessThan(field: Item.Field, value: any QueryFilterable)
//        case greaterThan(field: Item.Field, value: any QueryFilterable)
//
//        case and([Filter])
//        case or([Filter])
//
//        public enum Range<Value: Comparable & Sendable>: Sendable, Equatable {
//            case open(Swift.Range<Value>)
//            case closed(ClosedRange<Value>)
//        }
//
//        var codingKey: DynamicCodingKey {
//            return switch self {
//            case .equals(let field, _):
//                .field(field)
//            case .contains(let field, _):
//                .field(field)
//            case .lessThan(let field, _):
//                .field(field)
//            case .greaterThan(let field, _):
//                .field(field)
//
//            case .and:
//                "$and"
//            case .or:
//                "$or"
//            }
//        }
//
//        public func encode(to encoder: any Encoder) throws {
//            var container = encoder.container(keyedBy: DynamicCodingKey.self)
//            switch self {
//            case .contains(let field, let values):
//                let fieldKey = DynamicCodingKey.field(field)
//                var nested = container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: fieldKey)
//                try nested.encode(values, forKey: .field(field))
//            case .equals(let field, let value): <#code#>
//            case .greaterThan(let field, let value): <#code#>
//            case .lessThan(let field, let value): <#code#>
//            case .and(_): <#code#>
//            case .or(_): <#code#>
//            }
//        }
//    }
//}
//
//public extension Query {
//    enum Option: Sendable, Equatable {
//        case select(fields: Item.Field.AllCases = Item.Field.allCases)
//        case pagination(Pagination)
//        case populate(fields: Item.Field.AllCases)
//    }
//}
//
//public extension Query.Option {
//    struct Pagination: Sendable, Equatable, Hashable, Encodable {
//        let page: Int
//        let pageSize: Int
//    }
//}
