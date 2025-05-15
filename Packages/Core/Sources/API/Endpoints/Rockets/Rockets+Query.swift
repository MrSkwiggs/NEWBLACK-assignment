//
//  Rockets+Query.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Networking
import Entities

public extension Rockets {
    /// Rocket Query endpoint.
    final class QueryRequest: Rockets, PaginatedRequest, @unchecked Sendable {

        public typealias Item = Rocket

        public var body: ProvidedBody

        public override var path: String {
            super.path + "/query"
        }
        public override var method: Networking.Method { .post }

        init(
            filter: Item.Filter = .empty,
            options: [Item.Option],
        ) {
            body = .init(filter: filter, options: options)
            super.init()
        }
    }
}

public extension API.Rockets {

    /// Fetches a paginated list of rockets.
    /// - Parameters:
    ///   - page: The page number to retrieve.
    ///   - pageSize: The number of items per page.
    /// - Returns: A paginated response of rockets.
    static func fetchAll(
        page: Int = 0,
        pageSize: Int = 20
    ) async throws -> Rockets.QueryRequest.Response {
        try await API.shared.send(
            Rockets.QueryRequest(
                options: [
                    .pagination(.init(page: page, pageSize: pageSize))
                ]
            )
        )
    }

    static func fetch(byID rocketID: String) async throws -> Rocket? {
        try await API.shared.send(
            Rockets.QueryRequest(
                filter: .equals(field: .id, value: rocketID),
                options: [.pagination(.init(page: 0, pageSize: 1))]
            )
        ).items.first
    }
}
