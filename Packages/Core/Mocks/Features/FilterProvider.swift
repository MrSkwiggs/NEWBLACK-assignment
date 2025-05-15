//
//  FilterProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Shared

public actor MockFilterProvider: FilterProviding {
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
