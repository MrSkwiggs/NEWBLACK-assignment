//
//  Launches+Query.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Networking

public extension Launches {
    final class QueryRequest: Launches, PaginatedRequest, @unchecked Sendable {

        public typealias Item = LaunchDTO
        
        public var body: ProvidedBody

        public override var path: String {
            super.path + "/query"
        }
        public override var method: Networking.Method { .post }

        init(
            filter: Item.Filter = .empty,
            options: [Query<Item>.Option],
        ) {
            body = .init(filter: filter, options: options)
            super.init()
        }
    }
}

public extension API.Launches {

    /// Queries launches with the given filter, select, populate, page, and page size.
    /// - Parameters:
    ///   - filter: A filter to apply to the query.
    ///   - select: Select fields to include in the response.
    ///   - populate: Fields to populate in the response.
    ///   - page: The page number to retrieve.
    ///   - pageSize: The number of items per page.
    /// - Returns: A paginated response containing the queried launches.
    static func query(
        filter: LaunchDTO.Filter = .empty,
        select: LaunchDTO.Field.AllCases = LaunchDTO.Field.allCases,
        populate: LaunchDTO.Field.AllCases = [],
        page: Int,
        pageSize: Int
    ) async throws -> Launches.QueryRequest.Response {
        try await API.shared.send(
            Launches.QueryRequest(
                filter: filter,
                options: [
                    .pagination(.init(page: page, pageSize: pageSize)),
                    .select(fields: select),
                    .populate(fields: populate)
                ]
            )
        )
    }
}
