//
//  FilterProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Shared

@MainActor
public final class MockFilterProvider: FilterProviding {
    public var filters: [DateRangeFilter]
    public var isActive: Bool

    public init(
        filters: [DateRangeFilter] = [],
        isActive: Bool = false
    ) {
        self.filters = filters
        self.isActive = isActive
    }
}

public extension MockFilterProvider {
    static let empty = MockFilterProvider(
        filters: [],
        isActive: false
    )

    static let one = MockFilterProvider(
        filters: [
            DateRangeFilter(
                start: Date(timeIntervalSince1970: 946684800),
                end: Date(timeIntervalSince1970: 2147483647)
            )
        ],
        isActive: true
    )

    static let two = MockFilterProvider(
        filters: [
            DateRangeFilter(
                start: Date(timeIntervalSince1970: 0),
                end: Date(timeIntervalSince1970: 1000000000)
            ),
            DateRangeFilter(
                start: Date(timeIntervalSince1970: 946684800),
                end: Date(timeIntervalSince1970: 2147483647)
            )
        ],
        isActive: true
    )
}
