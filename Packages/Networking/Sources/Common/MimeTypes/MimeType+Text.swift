//
//  Text.swift
//  Networking
//

public extension MimeType {
    // This may look redundant / useless, but it allows us to neatly construct Text mimetypes from static values
    // i.e let mime: MimeType = .text(.html)
    static func text(_ text: Text) -> Text {
        text
    }

    var isText: Bool {
        self is Text
    }

    class Text: MimeType, @unchecked Sendable {
        required init(rawValue: String) {
            super.init(rawValue: "text/\(rawValue)")
        }

        public static let plain: Text = "plain"
        public static let html: Text = "html"
    }
}
