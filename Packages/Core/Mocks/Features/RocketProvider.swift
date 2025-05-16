//
//  RocketProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Entities
import Shared
import Foundation

public actor MockRocketProvider: RocketProviding {
    private var pages: [Result<Paginated<Rocket>, Error>]

    /// A closure that is called when `fetch(atPage:)` is called.
    /// This closure can be used to validate that the parameters passed to the function are correct, or that the function is called.
    /// It is useful for testing purposes.
    /// - Parameters:
    ///   - page: The page that is being fetched.
    ///   - filters: The filters that are being applied.
    ///   - willReturn: The result about to be returned.
    /// - Returns: The result that will be used and returned by the current call to `fetch`. You can override the result by returning a different value or throwing an error
    public typealias RocketsHook = @Sendable (
        _ page: Int,
        _ willReturn: Result<Paginated<Rocket>, Error>
    ) -> Result<Paginated<Rocket>, Error>

    /// A closure that is called when `fetch(byRocketID:)` is called.
    /// This closure can be used to validate that the parameters passed to the function are correct, or that the function is called.
    /// It is useful for testing purposes.
    /// - Parameters:
    ///  - rocketID: The ID of the rocket that is being fetched.
    ///  - willReturn: The result about to be returned.
    /// - Returns: The result that will be used and returned by the current call to `fetch(byRocketID:)`. You can override the result by returning a different value or throwing an error
    public typealias RocketHook = @Sendable (
        _ rocketID: String,
        _ willReturn: Result<Rocket?, Error>
    ) -> Result<Rocket?, Error>

    private let handler: MockHandler

    private let hookRockets: RocketsHook
    private let hookRocket: RocketHook

    /// Creates a mock provider with the given pages.
    /// - Parameters:
    ///   - pages: A list of success / failures to return.
    ///   - hookRocketes: This closure is called during the `fetch` method. It can be used as a hook when performing tests, validating that certain parameters are passed or that the function is called. You c
    public init(
        pages: [Result<Paginated<Rocket>, Error>],
        duration: MockDuration = .short,
        hookRockets: @escaping RocketsHook = { _, response in response },
        hookRocket: @escaping RocketHook = { _, response in response }
    ) {
        self.pages = pages
        self.handler = .init(duration)
        self.hookRockets = hookRockets
        self.hookRocket = hookRocket
    }

    public func fetch(
        atPage page: Int,
    ) async throws -> Paginated<Rocket> {
        let response = pages.isEmpty ? .success(.empty()) : pages.removeFirst()

        return try await handler { [hookRockets] in
            try hookRockets(page, response).get()
        }
    }

    public func fetch(rocketByID rocketID: String) async throws -> Rocket? {
        let response = pages.isEmpty ? .success(nil) : pages.removeFirst().map { $0.items.first }

        return try await handler { [hookRocket] in
            try hookRocket(rocketID, response).get()
        }
    }
}

public extension MockRocketProvider {

    /// A mock provider that returns an empty list of launches.
    static func empty(
        mockDuration: MockDuration = .short,
        hookRockets: @escaping RocketsHook = { _, response in response },
        hookRocket: @escaping RocketHook = { _, response in response }
    ) -> Self {
        .init(
            pages: [],
            duration: mockDuration,
            hookRockets: hookRockets,
            hookRocket: hookRocket
        )
    }

    /// A mock provider that returns a list of launches.
    static func success(
        mockDuration: MockDuration = .short,
        hookRockets: @escaping RocketsHook = { _, response in response },
        hookRocket: @escaping RocketHook = { _, response in response }
    ) -> Self {
        .init(
            pages: [
                .success(.init(items: [.starship, .falcon9], page: 1, pageSize: 2, nextPage: 2)),
                .success(.init(items: [.kraken], page: 2, pageSize: 2, nextPage: nil))
            ],
            duration: mockDuration,
            hookRockets: hookRockets,
            hookRocket: hookRocket
        )
    }

    /// A mock provider that returns a failure.
    static func failure(
        mockDuration: MockDuration = .short,
        hookRockets: @escaping RocketsHook = { _, response in response },
        hookRocket: @escaping RocketHook = { _, response in response }
    ) -> Self {
        .init(
            pages: [
                .failure(MockError()),
            ],
            duration: mockDuration,
            hookRockets: hookRockets,
            hookRocket: hookRocket
        )
    }
}
