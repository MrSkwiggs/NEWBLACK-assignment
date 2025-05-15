//
//  Paginated.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A structure representing a paginated response.
public struct Paginated<Item: Sendable & Decodable>: Sendable, Decodable {
    /// The items contained in the current page.
    public let items: [Item]
    /// The current page number.
    public let page: Int
    /// The number of items per page.
    public let pageSize: Int
    /// The next page number, if available.
    public let nextPage: Int?

    enum CodingKeys: String, CodingKey {
        case items = "docs"
        case page
        case pageSize = "limit"
        case nextPage = "nextPage"
    }

    package init(items: [Item], page: Int, pageSize: Int, nextPage: Int?) {
        self.items = items
        self.page = page
        self.pageSize = pageSize
        self.nextPage = nextPage
    }

    /// An empty paginated response.
    package static func empty() -> Self {
        .init(items: [], page: 0, pageSize: 0, nextPage: nil)
    }
}
