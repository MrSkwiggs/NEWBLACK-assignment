//
//  LaunchDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public struct LaunchDTO: DTO {
    public let id: String
    public let date: Date
    public let isUpcoming: Bool
    public let name: String
    public let launchpadID: String
    public let links: LinksDTO
    public let rocketID: String
    public let isSuccess: Bool?
    public let failures: [FailureDTO]?
    public let details: String?

    public init(
        id: String,
        date: Date,
        isUpcoming: Bool,
        name: String,
        launchpadID: String,
        links: LinksDTO,
        rocketID: String,
        isSuccess: Bool?,
        failures: [FailureDTO]?,
        details: String?
    ) {
        self.id = id
        self.date = date
        self.isUpcoming = isUpcoming
        self.name = name
        self.launchpadID = launchpadID
        self.links = links
        self.rocketID = rocketID
        self.isSuccess = isSuccess
        self.failures = failures
        self.details = details
    }

    public enum Field: String, CodingKey, DTOField {
        case id
        case date = "date_unix"
        case isUpcoming = "upcoming"
        case name
        case launchpadID = "launchpad"
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
        self.launchpadID = try container.decode(.launchpadID)
        self.links = try container.decode(.links)
        self.rocketID = try container.decode(.rocketID)
        self.isSuccess = try container.decodeIfPresent(.isSuccess)
        self.failures = try container.decodeIfPresent(.failures)
        self.details = try container.decodeIfPresent(.details)
    }
}
