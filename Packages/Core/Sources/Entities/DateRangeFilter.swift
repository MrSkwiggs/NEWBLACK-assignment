//
//  DateRangeFilter.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

/// A filter that represents a date range.
public struct DateRangeFilter: Sendable, Hashable, Equatable, Identifiable, Codable {
    public let id: UUID
    /// The date range.
    public let range: ClosedRange<Date>

    /// Creates a date range filter with the given date range.
    public init(range: ClosedRange<Date>) {
        self.id = UUID()
        self.range = range
    }

    /// Creates a date range filter with the given start and end dates.
    public init(start: Date, end: Date) {
        self.init(range: start...end)
    }
}
