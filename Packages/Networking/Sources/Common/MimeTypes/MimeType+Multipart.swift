//
//  Multipart.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

import Foundation

public extension MimeType {
    // This may look redundant / useless, but it allows us to neatly construct Multipart mimetypes from static values
    // i.e let mime: MimeType = .multipart(.form())
    static func multipart(_ multipart: Multipart) -> Multipart {
        multipart
    }

    var isMultipart: Bool {
        self is Multipart
    }

    /// A MIME type for multipart data.
    class Multipart: MimeType, @unchecked Sendable {

        public enum Boundary: Sendable {
            case form(id: String)
            case byteRange(id: String)

            public var name: String {
                switch self {
                case .form:
                    return "form-data"
                case .byteRange:
                    return "byteranges"
                }
            }

            public var id: String {
                switch self {
                case let .form(id), let .byteRange(id):
                    return id
                }
            }
        }

        public let boundary: Boundary

        private init(boundary: Boundary) {
            self.boundary = boundary
            super.init(rawValue: "multipart/\(boundary.name); boundary=\(boundary.id)")
        }

        /// Instantiates a multipart as form-data with the given boundary identifier
        required convenience init(rawValue: String) {
            self.init(boundary: .form(id: rawValue))
        }

        /// Instantiates a multipart as byte-range with the given boundary identifier
        public static func byteRange(_ boundary: String = UUID().uuidString) -> Multipart {
            .init(boundary: .byteRange(id: boundary))
        }

        /// Instantiates a multipart as form-data with the given boundary identifier
        public static func form(_ boundary: String = UUID().uuidString) -> Multipart {
            .init(boundary: .form(id: boundary))
        }
    }
}
