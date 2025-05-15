//
//  Query+Option.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public extension Query {
    enum Option: Sendable {
        /// Selects specific fields to be included in the response.
        /// - Warning: Use of this option will break the decoding of `Item` if it expects different fields.
        case select(fields: Item.Field.AllCases = Item.Field.allCases)
        /// Pagination options for the request.
        case pagination(Pagination)
        /// Populates specific nested fields which would otherwise only return their associated ID.
        /// - Warning: Use of this option will break the decoding of `Item` if it doesn't expect the given nested fields to be returned in full.
        case populate(fields: Item.Field.AllCases)
        /// Sorts the results based on the specified fields.
        case sort([Sort])

        func encode(to container: inout KeyedEncodingContainer<DynamicCodingKey>) throws {
            switch self {
            case .select(let fields):
                guard !fields.isEmpty && fields != Item.Field.allCases else {
                    return
                }
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
