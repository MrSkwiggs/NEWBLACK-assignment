//
//  Authorization.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//


import Foundation

public extension Headers {
    /// A type representing the `Authorization` header values.
    struct Authorization: Sendable, RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Codable {
        public typealias RawValue = String

        public let rawValue: RawValue

        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        public static func bearer(token: String) -> Authorization {
            "Bearer \(token)"
        }

        public static func basic(token: String) -> Authorization {
            "Basic \(token)"
        }
    }
}
