//
//  PaginatedRequest.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Networking
import Entities

/// A request that uses and returns a paginated response.
protocol PaginatedRequest: Request, BodyProvider, Sendable where Response == Paginated<Item>, ProvidedBody == Query<Item> {
    associatedtype Item: DTO
}
