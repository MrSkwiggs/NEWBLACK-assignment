//
//  LaunchDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A structure representing a launch.
public struct Launch: DTO {
    /// The unique identifier of the launch.
    public let id: String
    /// The date of the launch.
    public let date: Date
    /// A boolean indicating whether the launch is upcoming.
    public let isUpcoming: Bool
    /// The name of the launch.
    public let name: String
    /// The launchpad where the launch takes place.
    public let launchpad: Launchpad
    /// Various links related to the launch.
    public let links: Links
    /// The unique identifier of the rocket used in the launch.
    public let rocketID: String
    /// Whether the launch was successful.
    public let isSuccess: Bool?
    /// An array of failures associated with the launch, if any.
    public let failures: [Failure]?
    /// Additional details about the launch, if any.
    public let details: String?

    public init(
        id: String,
        date: Date,
        isUpcoming: Bool,
        name: String,
        launchpad: Launchpad,
        links: Links,
        rocketID: String,
        isSuccess: Bool?,
        failures: [Failure]?,
        details: String?
    ) {
        self.id = id
        self.date = date
        self.isUpcoming = isUpcoming
        self.name = name
        self.launchpad = launchpad
        self.links = links
        self.rocketID = rocketID
        self.isSuccess = isSuccess
        self.failures = failures
        self.details = details
    }

    public enum Field: String, CodingKey, DTOField {
        case id
        case date = "date_utc"
        case isUpcoming = "upcoming"
        case name
        case launchpad = "launchpad"
        case links
        case rocketID = "rocket"
        case isSuccess = "success"
        case failures
        case details
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Field.self)
        self.id = try container.decode(.id)
        self.date = try container.decode(.date)
        self.isUpcoming = try container.decode(.isUpcoming)
        self.name = try container.decode(.name)
        self.launchpad = try container.decode(.launchpad)
        self.links = try container.decode(.links)
        self.rocketID = try container.decode(.rocketID)
        self.isSuccess = try container.decodeIfPresent(.isSuccess)
        self.failures = try container.decodeIfPresent(.failures)
        self.details = try container.decodeIfPresent(.details)
    }
}
