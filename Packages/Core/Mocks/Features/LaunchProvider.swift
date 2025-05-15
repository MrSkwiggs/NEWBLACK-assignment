//
//  LaunchProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import API
import Shared
import Foundation

public actor MockLaunchProvider: LaunchProviding {
    private var replies: [Result<Paginated<Launch>, Error>]
    private let hookLaunches: (_ page: Int, _ filters: [DateRangeFilter]) -> Void

    public init(
        replies: [Result<Paginated<Launch>, Error>],
        hookLaunches: @escaping (_ page: Int, _ filters: [DateRangeFilter]) -> Void = { _, _ in }
    ) {
        self.replies = replies
        self.hookLaunches = hookLaunches
    }

    public func fetch(
        atPage page: Int,
        filters: [DateRangeFilter]
    ) async throws -> Paginated<Launch> {
        guard !replies.isEmpty else {
            return .empty()
        }

        hookLaunches(page, filters)

        return try replies.removeFirst().get()
    }
}

public extension MockLaunchProvider {
    /// A mock provider that returns an empty list of launches.
    static let empty: MockLaunchProvider = .init(replies: [])

    /// A mock provider that returns a list of launches.
    static let success: MockLaunchProvider = .init(
        replies: [
            .success(.init(items: [.krakenUnleashed, .minmusMambo], page: 1, pageSize: 2, nextPage: 2)),
            .success(.init(items: [.munaholicAchievement, .seaOfKerbalDebut], page: 2, pageSize: 2, nextPage: nil))
        ]
    )

    /// A mock provider that returns a failure.
    static let failure: MockLaunchProvider = .init(
        replies: [
            .failure(MockError.mock),
        ]
    )
}
