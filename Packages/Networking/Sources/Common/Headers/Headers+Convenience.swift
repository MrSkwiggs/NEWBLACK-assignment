//
//  Headers+Convenience.swift
//  Networking
//

import Foundation

public extension Headers {
    /// The content type header for the request.
    var contentType: MimeType? {
        get {
            get(.contentType)
        }
        set {
            set(newValue, for: .contentType)
        }
    }

    /// The accept type header for the request.
    var accept: MimeType? {
        get {
            get(.accept)
        }
        set {
            set(newValue, for: .accept)
        }
    }

    /// The user agent header for the request.
    var userAgent: String? {
        get {
            get(.userAgent)
        }
        set {
            set(newValue, for: .userAgent)
        }
    }

    /// The authorization header for the request.
    var authorization: Authorization? {
        get {
            get(.authorization)
        }
        set {
            set(newValue, for: .authorization)
        }
    }

    /// A custom cookie header for the request.
    var cookie: String? {
        get {
            get(.cookie)
        }
        set {
            set(newValue, for: .cookie)
        }
    }
}
