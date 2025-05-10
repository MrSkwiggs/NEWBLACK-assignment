//
//  MultipleRawValuesRepresentable.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

import Foundation

/// A protocol that allows a type to have multiple raw values.
public protocol MultipleRawValuesRepresentable: CaseIterable {
    /// The identity raw value for this type.
    var rawValue: String { get }
    /// The alternate raw values for this type.
    var alternateRawValues: [String] { get }

    init(rawValue: String, alternateRawValues: [String])
}

public extension Collection where Element: MultipleRawValuesRepresentable {
    /// Find the first element that matches the given raw value or any of its alternate raw values.
    func match(_ other: Element) -> Element? {
        for element in Element.allCases {
            if element.rawValue == other.rawValue || element.alternateRawValues.contains(other.rawValue) {
                return element
            }
        }
        return nil
    }
}
