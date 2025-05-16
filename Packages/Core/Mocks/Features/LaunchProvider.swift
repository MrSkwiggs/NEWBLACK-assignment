//
//  LaunchProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Entities
import Shared
import Foundation

public actor MockLaunchProvider: LaunchProviding {
    private var pages: [Result<Paginated<Launch>, Error>]

    /// A closure that is called when `fetch` is called.
    /// This closure can be used to validate that the parameters passed to the function are correct, or that the function is called.
    /// It is useful for testing purposes.
    /// - Parameters:
    ///   - page: The page that is being fetched.
    ///   - filters: The filters that are being applied.
    ///   - willReturn: The result about to be returned.
    /// - Returns: The result that will be used and returned by the current call to `fetch`. You can override the result by returning a different value or throwing an error
    public typealias LaunchesHook = @Sendable (
        _ page: Int,
        _ filters: [DateRangeFilter],
        _ willReturn: Result<Paginated<Launch>, Error>
    ) -> Result<Paginated<Launch>, Error>

    private let hookLaunches: LaunchesHook

    private let handler: MockHandler

    /// Creates a mock provider with the given pages.
    /// - Parameters:
    ///   - pages: A list of success / failures to return.
    ///   - hookLaunches: This closure is called during the `fetch` method. It can be used as a hook when performing tests, validating that certain parameters are passed or that the function is called. You c
    public init(
        pages: [Result<Paginated<Launch>, Error>],
        duration: MockDuration = .oneSecond,
        hookLaunches: @escaping LaunchesHook = { _, _, response in response }
    ) {
        self.pages = pages
        self.handler = .init(duration)
        self.hookLaunches = hookLaunches
    }

    public func fetch(
        atPage page: Int,
        filters: [DateRangeFilter]
    ) async throws -> Paginated<Launch> {
        let response = pages.isEmpty ? .success(.empty()) : pages.first!

        defer {
            if case .success = pages.first {
                pages.removeFirst()
            }
        }
        return try await handler { [hookLaunches] in
            try hookLaunches(page, filters, response).get()
        }
    }
}

public extension MockLaunchProvider {
    /// A mock provider that returns an empty list of launches.
    static func empty(
        mockDuration: MockDuration = .oneSecond,
        _ hookLaunches: @escaping LaunchesHook = { _, _, response in response }
    ) -> Self {
        .init(
            pages: [],
            duration: mockDuration,
            hookLaunches: hookLaunches
        )
    }

    /// A mock provider that returns a list of launches.
    static func success(
        mockDuration: MockDuration = .oneSecond,
        hookLaunches: @escaping LaunchesHook = { _, _, response in response }
    ) -> Self {
        .init(
            pages: [
                .success(.init(items: [.krakenUnleashed, .minmusMambo], page: 1, pageSize: 2, nextPage: 2)),
                .success(.init(items: [.munaholicAchievement, .seaOfKerbalDebut], page: 2, pageSize: 2, nextPage: nil))
            ],
            duration: mockDuration,
            hookLaunches: hookLaunches
        )
    }

    /// A mock provider that returns a failure.
    static func failure(
        mockDuration: MockDuration = .oneSecond,
        hookLaunches: @escaping LaunchesHook = { _, _, response in response
        }) -> Self {
        .init(
            pages: [
                .failure(MockError()),
            ],
            duration: mockDuration,
            hookLaunches: hookLaunches
        )
    }
}
