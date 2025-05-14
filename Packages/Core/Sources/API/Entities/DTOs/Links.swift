//
//  LinksDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A structure representing various links related to a launch.
public struct Links: APIModel {
    /// The URL of the webcast for the launch.
    public let webcast: URL?
    /// The URL of the Wikipedia page for the launch.
    public let wikipedia: URL?

    /// An array of image URLs related to the launch.
    public let images: [URL]

    public init(
        webcast: URL?,
        wikipedia: URL?,
        images: [URL] = []
    ) {
        self.webcast = webcast
        self.wikipedia = wikipedia
        self.images = images
    }

    enum CodingKeys: String, CodingKey {
        case webcast
        case wikipedia
        case images = "flickr"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.webcast = try container.decodeIfPresent(URL.self, forKey: .webcast)
        self.wikipedia = try container.decodeIfPresent(URL.self, forKey: .wikipedia)
        let imagesContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .images)
        images = try imagesContainer.decodeIfPresent("original") ?? imagesContainer.decodeIfPresent("small") ?? []
    }

    /// A computed property indicating whether the links contain any URLs (barring image URLs).
    public var hasLinks: Bool {
        return (webcast != nil || wikipedia != nil)
    }
}
