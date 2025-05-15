//
//  DateProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//


import Foundation

/// A simple class that provides the current time and other date/time operations.
public final class DateProvider: Sendable {

    package init(currentDate: @escaping @Sendable () -> Date) {
        self.now = currentDate
    }

    /// Returns the current time
    public let now: @Sendable () -> Date

    /// Returns a date advanced by the given time interval
    public func date(after timeInterval: TimeInterval) -> Date {
        now().addingTimeInterval(timeInterval)
    }
}

public extension DateProvider {
    /// The main provider, uses `Date.now`
    static var main: DateProvider {
        .init {
            Date()
        }
    }
}
