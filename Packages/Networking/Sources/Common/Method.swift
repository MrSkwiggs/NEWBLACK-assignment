//
//  Method.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

import Foundation

public struct Method: Sendable, RawRepresentable, ExpressibleByStringLiteral, Codable, CustomStringConvertible, CustomDebugStringConvertible, Equatable, Hashable {
    public typealias RawValue = String

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public var description: String {
        rawValue
    }

    public var debugDescription: String {
        "HTTP Method: \(rawValue)"
    }

    public static let head: Method = "HEAD"
    public static let get: Method = "GET"
    public static let post: Method = "POST"
    public static let patch: Method = "PATCH"
    public static let put: Method = "PUT"
    public static let delete: Method = "DELETE"
}
