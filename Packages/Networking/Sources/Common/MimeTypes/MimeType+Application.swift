//
//  Application.swift
//  Networking
//

public extension MimeType {
    // This may look redundant / useless, but it allows us to neatly construct Application mimetypes from static values
    // i.e let mime: MimeType = .application(.json)
    static func application(_ application: Application) -> Application {
        application
    }

    /// Check if the MIME type is an application type
    var isApplication: Bool {
        self is Application
    }

    /// Application MIME types
    class Application: MimeType, @unchecked Sendable {
        public required init(rawValue: String) {
            super.init(rawValue: "application/\(rawValue)")
        }

        public static let json: Application = "json"
        public static let javascript: Application = "javascript"
        public static let data: Application = "octet-stream"
    }
}
