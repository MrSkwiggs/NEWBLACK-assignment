//
//  Sort.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation
import Entities

public extension Query.Option {
    /// Sorting configuration for the query.
    struct Sort: Sendable, Equatable, Hashable, Encodable {
        public let field: Item.Field
        public let order: SortOrder

        private init(field: Item.Field, order: SortOrder) {
            self.field = field
            self.order = order
        }

        /// Creates a new sort option.
        /// - Parameters:
        ///   - field: The field to sort by.
        ///   - order: The order to sort by. Defaults to `.forward`.
        /// - Returns: A new sort option.
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
