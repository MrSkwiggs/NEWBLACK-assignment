//
//  Launches+Query.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Networking
import Entities

public extension Launches {
    /// Launches Query endpoint.
    final class QueryRequest: Launches, PaginatedRequest, @unchecked Sendable {

        public typealias Item = Launch
        
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
        filter: Launch.Filter = .empty,
        select: Launch.Field.AllCases = Launch.Field.allCases,
        populate: Launch.Field.AllCases = [],
        sort: [Launch.Option.Sort] = [],
        page: Int,
        pageSize: Int
    ) async throws -> Launches.QueryRequest.Response {
        try await API.shared.send(
            Launches.QueryRequest(
                filter: filter,
                options: [
                    .pagination(.init(page: page, pageSize: pageSize)),
                    .select(fields: select),
                    .populate(fields: populate),
                    .sort(sort)
                ]
            )
        )
    }


    /// Returns a paginated list of upcoming launches.
    /// - Parameters:
    ///   - page: The page number to retrieve.
    ///   - pageSize: The number of items per page.
    /// - Returns: A paginated response containing upcoming launches.
    static func upcoming(
        sort: [Launch.Option.Sort] = [.by(.date, .reverse)],
        page: Int = 0,
        pageSize: Int = 20
    ) async throws -> Launches.QueryRequest.Response {
        try await API.shared.send(
            Launches.QueryRequest(
                filter: .equals(field: .isUpcoming, value: true),
                options: [
                    .pagination(.init(page: page, pageSize: pageSize)),
                    .populate(fields: [.launchpad]),
                    .sort(sort)
                ]
            )
        )
    }

    /// Returns a paginated list of past launches.
    /// - Parameters:
    ///  - page: The page number to retrieve.
    ///  - pageSize: The number of items per page.
    /// - Returns: A paginated response containing past launches.
    static func past(
        sort: [Launch.Option.Sort] = [.by(.date, .reverse)],
        page: Int = 0,
        pageSize: Int = 20
    ) async throws -> Launches.QueryRequest.Response {
        try await API.shared.send(
            Launches.QueryRequest(
                filter: .equals(field: .isUpcoming, value: false),
                options: [
                    .pagination(.init(page: page, pageSize: pageSize)),
                    .populate(fields: [.launchpad]),
                    .sort(sort)
                ]
            )
        )
    }
}
