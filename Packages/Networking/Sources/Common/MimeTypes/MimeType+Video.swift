//
//  Video.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//


public extension MimeType {
    // This may look redundant / useless, but it allows us to neatly construct Video mimetypes from static values
    // i.e let mime: MimeType = .video(.mov)
    static func video(_ video: Video) -> Video {
        video
    }

    var isVideo: Bool {
        self is Video
    }

    final class Video: MimeType, @unchecked Sendable, ExpressibleByMultipleRawValuesMimeType, MultipleRawValuesRepresentable {
        public static let typeIdentifier: String = "video"

        public let alternateRawValues: [String]

        public static let allCases: [MimeType.Video] = [
            .mp4,
            .mpeg,
            .mov
        ]

        public init(rawValue: String, alternateRawValues: [String]) {
            self.alternateRawValues = alternateRawValues
            super.init(rawValue: rawValue)
        }

        public required init(rawValue: String) {
            self.alternateRawValues = []
            super.init(rawValue: "\(Self.typeIdentifier)/\(rawValue)")
        }

        public static let mp4: Video = "mp4"
        public static let mov: Video = "mov"
        public static let mpeg: Video = ["mpeg", "mpg"]
    }
}
