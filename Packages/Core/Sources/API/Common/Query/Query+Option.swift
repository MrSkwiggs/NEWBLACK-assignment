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
