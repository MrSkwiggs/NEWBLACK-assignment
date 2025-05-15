//
//  LauncProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import API
import Entities

/// A type that can provide launches
public protocol LaunchProviding: Sendable, Actor {
    /// Fetches launches from the API with the given filters.
    func fetch(atPage page: Int, filters: [DateRangeFilter]) async throws -> Paginated<Launch>
}

public actor LaunchProvider: LaunchProviding {
    public func fetch(
        atPage page: Int,
        filters: [DateRangeFilter] = []
    ) async throws -> Paginated<Launch> {
        try await API.Launches.query(
            filter: .or(filters.map { .range(field: .date, range: $0.range) }),
            populate: [.launchpad],
            sort: [.by(.isUpcoming, .reverse), .by(.date, .reverse)],
            page: page,
            pageSize: 10
        )
    }
}
