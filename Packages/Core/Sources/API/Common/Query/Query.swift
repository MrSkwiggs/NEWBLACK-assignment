//
//  Query.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation

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
