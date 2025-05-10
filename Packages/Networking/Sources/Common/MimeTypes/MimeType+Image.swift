//
//  Image.swift
//  Networking
//
//  Created by Dorian on 17/04/2025.
//

public extension MimeType {
    // This may look redundant / useless, but it allows us to neatly construct Image mimetypes from static values
    // i.e let mime: MimeType = .image(.gif)
    static func image(_ image: Image) -> Image {
        image
    }

    /// Checks if the MIME type is an image type.
    var isImage: Bool {
        self is Image
    }

    /// A type that represents an image MIME type.
    final class Image: MimeType, @unchecked Sendable, ExpressibleByMultipleRawValuesMimeType, MultipleRawValuesRepresentable {
        public static let typeIdentifier: String = "image"

        public let alternateRawValues: [String]

        public static let allCases: [MimeType.Image] = [
            .cr2,
            .cr3,
            .dng,
            .png,
            .jpeg,
            .tiff,
            .gif
        ]

        public init(rawValue: String, alternateRawValues: [String]) {
            self.alternateRawValues = alternateRawValues
            super.init(rawValue: rawValue)
        }

        public required init(rawValue: String) {
            self.alternateRawValues = []
            super.init(rawValue: "\(Self.typeIdentifier)/\(rawValue)")
        }

        public required convenience init(stringLiteral value: StringLiteralType) {
            self.init(rawValue: value)
        }

        public static let jpeg: Image = ["jpeg", "jpg"]
        public static let png: Image = "png"
        public static let dng: Image = "dng"
        public static let cr2: Image = "cr2"
        public static let cr3: Image = "cr3"
        public static let tiff: Image = ["tiff", "tif"]
        public static let gif: Image = "gif"
    }
}
