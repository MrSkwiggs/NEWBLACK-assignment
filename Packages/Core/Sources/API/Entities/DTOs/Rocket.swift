//
//  RocketDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents a Rocket.
public struct Rocket: DTO {
    /// The ID of the Rocket.
    public let id: String
    /// The name of the Rocket.
    public let name: String
    /// The type of the Rocket.
    public let type: String
    /// Whether or not the Rocket is active/in service.
    public let isActive: Bool
    /// The mass of the Rocket.
    public let mass: Measurement<UnitMass>
    /// The height of the Rocket.
    public let height: Measurement<UnitLength>
    /// The diameter of the Rocket.
    public let diameter: Measurement<UnitLength>
    /// The engine configuration of the Rocket.
    public let engines: Engines
    /// The success rate of the Rocket, expressed as a percentage.
    public let successRate: Double
    /// When the Rocket performed its first flight.
    public let firstFlight: Date?
    /// Some images of the Rocket.
    public let imageURLs: [URL]
    /// A link to the Rocket's Wikipedia page.
    public let wikipediaURL: URL?
    /// A description of the Rocket.
    public let description: String

    package init(
        id: String,
        name: String,
        type: String,
        isActive: Bool,
        mass: Measurement<UnitMass>,
        height: Measurement<UnitLength>,
        diameter: Measurement<UnitLength>,
        engines: Engines,
        successRate: Double,
        firstFlight: Date? = nil,
        imageURLs: [URL],
        wikipediaURL: URL? = nil,
        description: String
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.isActive = isActive
        self.mass = mass
        self.height = height
        self.diameter = diameter
        self.engines = engines
        self.successRate = successRate
        self.firstFlight = firstFlight
        self.imageURLs = imageURLs
        self.wikipediaURL = wikipediaURL
        self.description = description
    }

    public enum Field: String, CodingKey, DTOField {
        case id
        case name
        case type
        case isActive = "active"
        case mass
        case height
        case diameter
        case engines
        case successRate = "success_rate_pct"
        case firstFlight = "first_flight"
        case imageURLs = "flickr_images"
        case wikipediaURL = "wikipedia"
        case description
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Field.self)
        self.id = try container.decode(.id)
        self.name = try container.decode(.name)
        self.type = try container.decode(.type)
        self.isActive = try container.decode(.isActive)

        let massContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .mass)
        self.mass = .init(value: try massContainer.decode("kg"), unit: .kilograms)

        let heightContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .height)
        self.height = .init(value: try heightContainer.decode("meters"), unit: .meters)

        let diameterContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .diameter)
        self.diameter = .init(value: try diameterContainer.decode("meters"), unit: .meters)

        self.engines = try container.decode(Engines.self, forKey: .engines)
        self.successRate = Double(try container.decode(Int.self, forKey: .successRate)) / 100.0
        let firstFlightString: String = try container.decode(.firstFlight)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.firstFlight = dateFormatter.date(from: firstFlightString)
        self.imageURLs = try container.decode([URL].self, forKey: .imageURLs)
        self.wikipediaURL = try container.decodeIfPresent(URL.self, forKey: .wikipediaURL)
        self.description = try container.decode(String.self, forKey: .description)
    }
}
