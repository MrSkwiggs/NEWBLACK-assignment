//
//  HTTPStatusCode.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

import Foundation

/// A structure representing HTTP status codes.
public struct HTTPStatusCode: Sendable, Hashable, Equatable, RawRepresentable, ExpressibleByIntegerLiteral, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias IntegerLiteralType = Int

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }

    public var category: Category {
        switch rawValue {
        case 100..<200: .informational
        case 200..<300: .success
        case 300..<400: .redirect
        case 400..<500: .clientError
        case 500..<600: .serverError

        default: .unknown
        }
    }

    public var description: String {
        "\(rawValue)"
    }

    public var debugDescription: String {
        description
    }

    // MARK: - Informational


    // MARK: - Success
    public static let ok: HTTPStatusCode = 200
    public static let created: HTTPStatusCode = 201
    public static let accepted: HTTPStatusCode = 202

    // MARK: - Redirection
    public static let multipleChoices: HTTPStatusCode = 300
    public static let movedPermanently: HTTPStatusCode = 301
    public static let temporaryRedirect: HTTPStatusCode = 307
    public static let permanentRedirect: HTTPStatusCode = 308

    // MARK: - Client Error
    public static let badRequest: HTTPStatusCode = 400
    public static let unauthorized: HTTPStatusCode = 401
    public static let paymentRequired: HTTPStatusCode = 402
    public static let forbidden: HTTPStatusCode = 403
    public static let notFound: HTTPStatusCode = 404
    public static let methodNotAllowed: HTTPStatusCode = 405

    // MARK: - Server Error
    public static let internalServerError: HTTPStatusCode = 500
    public static let notImplemented: HTTPStatusCode = 501
    public static let badGateway: HTTPStatusCode = 502
    public static let serviceUnavailable: HTTPStatusCode = 503

    /// A HTTP status code category, to which multiple status codes belong.
    public enum Category: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
        case informational, success, redirect, clientError, serverError, unknown

        public var description: String {
            switch self {
            case .informational:
                return "informational (100..<200)"
            case .success:
                return "success (200..<300)"
            case .redirect:
                return "redirect (300..<400)"
            case .clientError:
                return "client error (400..<500)"
            case .serverError:
                return "server error (500..<600)"
            case .unknown:
                return "unknown"
            }
        }

        public var debugDescription: String { description }
    }

    /// A type that represents validation for HTTP status codes.
    public enum Validation: Sendable, CustomStringConvertible, CustomDebugStringConvertible {
        /// Matches any status code of the specified category.
        case any(Category)

        /// Matches the specified status codes.
        case exact(Set<HTTPStatusCode>)

        /// Checks whether the given HTTP status code matches the validation criteria.
        public func matches(code: HTTPStatusCode) -> Bool {
            switch self {
            case .any(let category):
                return code.category == category
            case .exact(let set):
                return set.contains(code)
            }
        }

        public var description: String {
            switch self {
            case .any(let category):
                return "any \(category)"
            case .exact(let set):
                return set.description
            }
        }

        public var debugDescription: String { description }
    }
}

public extension HTTPURLResponse {
    /// Maps the HTTP status code to a `HTTPStatusCode` instance.
    var httpStatusCode: HTTPStatusCode {
        .init(rawValue: statusCode)
    }
}
