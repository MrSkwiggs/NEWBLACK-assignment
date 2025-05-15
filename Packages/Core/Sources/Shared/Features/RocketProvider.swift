//
//  RocketProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import API
import Entities

/// A type that can provide rockets
public protocol RocketProviding: Sendable, Actor {
    /// Fetches rockets from the API with the given filters.
    /// - Parameter page: The page number to fetch.
    /// - Returns: A paginated list of rockets.
    func fetch(atPage page: Int) async throws -> Paginated<Rocket>

    /// Fetches a rocket by its ID.
    /// - Parameter rocketID: The ID of the rocket to fetch.
    /// - Returns: A rocket if found, otherwise nil.
    func fetch(rocketByID rocketID: String) async throws -> Rocket?
}

public actor RocketProvider: RocketProviding {
    public func fetch(
        atPage page: Int
    ) async throws -> Paginated<Rocket> {
        try await API.Rockets
            .fetchAll(page: page)
    }

    public func fetch(rocketByID rocketID: String) async throws -> Rocket? {
        try await API.Rockets
            .fetch(byID: rocketID)
    }
}
