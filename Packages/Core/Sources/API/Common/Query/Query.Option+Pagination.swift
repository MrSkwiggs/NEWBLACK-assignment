//
//  Pagination.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

public extension Query.Option {
    /// Pagination configuration for paginated requests.
    struct Pagination: Sendable, Equatable, Hashable {
        let page: Int
        let pageSize: Int

        func encode(to container: inout KeyedEncodingContainer<DynamicCodingKey>) throws {
            try container.encode(page, forKey: "page")
            try container.encode(pageSize, forKey: "limit")
        }
    }
}
