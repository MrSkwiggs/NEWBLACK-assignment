//
//  DateProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Shared

public extension DateProvider {
    /// A mock Date provider that returns a fixed date.
    /// - Parameter date: The date this provider returns as the current date.
    /// - Returns: A DateProvider that always returns the same date.
    static func mock(usingFixed date: Date) -> Self {
        Self { date }
    }
}
