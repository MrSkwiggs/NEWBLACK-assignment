//
//  DynamicCodingKeys.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

/// A coding key that can use dynamic, runtime-defined identifiers
public struct DynamicCodingKey: CodingKey, ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, ExpressibleByStringInterpolation {
    public typealias StringLiteralType = String
    public typealias StringInterpolation = DefaultStringInterpolation
    public typealias IntegerLiteralType = Int

    public let stringValue: StringLiteralType
    public let intValue: IntegerLiteralType?

    // MARK: - Coding Key

    public init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = .init(stringValue)
    }

    public init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = "\(intValue)"
    }

    // MARK: - Literal

    public init(stringLiteral value: StringLiteralType) {
        self.stringValue = value
        self.intValue = .init(value)
    }

    public init(stringInterpolation: String) {
        self.stringValue = stringInterpolation
        self.intValue = .init(stringInterpolation)
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.intValue = value
        self.stringValue = "\(value)"
    }

    public init<T: RawRepresentable>(_ rawType: T) where T.RawValue == String {
        self.stringValue = rawType.rawValue
        self.intValue = nil
    }
}
