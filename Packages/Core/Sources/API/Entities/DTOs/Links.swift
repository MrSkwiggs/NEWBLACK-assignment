//
//  LinksDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public struct Links: APIModel {
    public let webcast: URL?
    public let wikipedia: URL?

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
}
