//
//  Paginated.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Entities

public extension Paginated {
    /// Returns a mock paginated object.
    static func mock(
        items: [Item] = [],
        page: Int = 1,
        pageSize: Int = 10,
        nextPage: Int? = 2
    ) -> Paginated {
        .init(
            items: items,
            page: page,
            pageSize: pageSize,
            nextPage: nextPage
        )
    }
}
