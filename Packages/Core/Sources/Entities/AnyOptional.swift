//
//  AnyOptional.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

/// A protocol that allows to check if an optional value is nil.
package protocol AnyOptional {
    /// Whether the optional value is nil or not.
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    package var isNil: Bool { self == nil }
}
