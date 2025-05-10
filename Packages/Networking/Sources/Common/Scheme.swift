//
//  Scheme.swift
//  Networking
//
//  Created by Dorian on 16/04/2025.
//

import Foundation

public struct Scheme: Sendable, RawRepresentable, ExpressibleByStringLiteral, Codable {
    public typealias RawValue = String

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public static let http: Scheme = "http"
    public static let https: Scheme = "https"
}
