//
//  LaunchpadDTO.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation

/// A data transfer object representing a launchpad.
public struct Launchpad: DTO {
    public enum Field: String, CodingKey, DTOField {
        case id
        case name
        case fullName = "full_name"
        case imageURLs = "images"
        case location
        case details
        case status
        case launches
    }

    /// The unique identifier of the launchpad.
    public let id: String
    /// The (short) name of the launchpad.
    public let name: String
    /// The full name of the launchpad.
    public let fullName: String
    /// An array of image URLs associated with the launchpad.
    public let imageURLs: [URL]
    /// A string containing details about the launchpad.
    public let details: String
    /// The status of the launchpad, indicating whether it is active or retired.
    public let status: Status
    /// The number of launches associated with the launchpad.
    public let launchCount: Int

    public init(
        id: String,
        name: String,
        fullName: String,
        imageURLs: [URL] = [],
        details: String,
        status: Status,
        launchCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.imageURLs = imageURLs
        self.details = details
        self.status = status
        self.launchCount = launchCount
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Field.self)
        self.id = try container.decode(.id)
        self.name = try container.decode(.name)
        self.fullName = try container.decode(.fullName)
        let imageContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .imageURLs)
        imageURLs = try imageContainer.decode("large")
        details = try container.decode(.details)
        status = try container.decode(.status)
        launchCount = try container.decode([String].self, forKey: .launches).count
    }
}

public extension Launchpad {
    /// The Status of a launchpad, indicating whether it is active or retired.
    enum Status: String, APIModel {
        /// The launchpad is active and operational.
        case active
        /// The launchpad is no longer in use.
        case retired
    }
}
