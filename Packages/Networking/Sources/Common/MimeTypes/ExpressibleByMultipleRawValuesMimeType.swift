//
//  ExpressibleByMultipleRawValuesMimeType.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

import Foundation

/// A protocol that allows a MiMeType to be initialized with multiple raw values.
public protocol ExpressibleByMultipleRawValuesMimeType: ExpressibleByArrayLiteral where ArrayLiteralElement == String {
    /// The type identifier for the MIME type.
    static var typeIdentifier: String { get }
}

public extension ExpressibleByMultipleRawValuesMimeType where Self: MimeType, Self: MultipleRawValuesRepresentable {
    init(arrayLiteral elements: String...) {
        guard !elements.isEmpty else {
            fatalError("RawValues should not be empty")
        }
        var values = elements.map { "\(Self.typeIdentifier)/\($0)".lowercased() }
        self.init(rawValue: values.removeFirst(), alternateRawValues: values)
    }

    init?(matching pathExtension: String) {
        guard let match = Self.allCases.match(.init(rawValue: pathExtension)) else {
            return nil
        }
        self = match
    }
}
