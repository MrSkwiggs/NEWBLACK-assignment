//
//  MimeType.swift
//  Networking
//

import Foundation

open class MimeType: @unchecked Sendable, Hashable, Equatable, RawRepresentable, ExpressibleByStringLiteral, ExpressibleByStringInterpolation, Codable, CustomStringConvertible, CustomDebugStringConvertible {
    public typealias RawValue = String

    public let rawValue: String

    public required init(rawValue: String) {
        self.rawValue = rawValue.lowercased()
    }

    public required convenience init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }

    public var description: String {
        rawValue
    }

    public var debugDescription: String {
        "\(Self.self) - \(rawValue)"
    }
}

public extension URL {
    var mimeType: MimeType? {
        guard pathExtension.isEmpty == false else { return nil }

        if let image = MimeType.Image(matching: pathExtension) {
            return image
        } else if let video = MimeType.Video(matching: pathExtension) {
            return video
        } else {
            return MimeType.Application(rawValue: pathExtension)
        }
    }
}
