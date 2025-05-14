//
//  LaunchpadDTO.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation

public struct Launchpad: DTO {
    public enum Field: String, CodingKey, DTOField {
        case id
        case name
        case imageURLs = "images"
        case location
        case details
        case status
        case launches
    }

    public let id: String
    public let name: String
    public let fullName: String
    public let imageURLs: [URL]
    public let details: String
    public let status: Status
    public let launchCount: Int

    public init(
        id: String,
        name: String,
        imageURLs: [URL] = [],
        details: String,
        status: Status,
        launchCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.fullName = name
        self.imageURLs = imageURLs
        self.details = details
        self.status = status
        self.launchCount = launchCount
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Field.self)
        self.id = try container.decode(.id)
        self.name = try container.decode(.name)
        self.fullName = try container.decode(.name)
        let imageContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .imageURLs)
        imageURLs = try imageContainer.decode("large")
        details = try container.decode(.details)
        status = try container.decode(.status)
        launchCount = try container.decode([String].self, forKey: .launches).count
    }
}

public extension Launchpad {
    enum Status: String, APIModel {
        case active
        case retired
    }
}
