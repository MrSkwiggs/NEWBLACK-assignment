//
//  Query+Option.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public extension Query {
    enum Option: Sendable {
        case select(fields: Item.Field.AllCases = Item.Field.allCases)
        case pagination(Pagination)
        case populate(fields: Item.Field.AllCases)
        case sort([Sort])

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

            case .sort(let sort):
                var nested = container.nestedUnkeyedContainer(forKey: "sort")
                for sort in sort {
                    try nested.encode(sort)
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

public extension Query.Option {
    struct Sort: Sendable, Equatable, Hashable, Encodable {
        public let field: Item.Field
        public let order: SortOrder

        private init(field: Item.Field, order: SortOrder) {
            self.field = field
            self.order = order
        }

        public static func by(_ field: Item.Field, _ order: SortOrder = .forward) -> Sort {
            .init(field: field, order: order)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(field.rawValue)
            switch order {
            case .forward:
                try container.encode("asc")
            case .reverse:
                try container.encode("desc")
            }
        }
    }
}
