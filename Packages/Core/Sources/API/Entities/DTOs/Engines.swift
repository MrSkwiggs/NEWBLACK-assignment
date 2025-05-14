//
//  EnginesDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the engines of a rocket
public struct Engines: APIModel {

    /// The ISP of the engine
    public let isp: ISP
    /// The thrust of the engine
    public let thrust: Thrust
    /// The count of engines
    public let count: Int
    /// The type of the engine
    public let type: String
    /// One of the two propellants used in the engine
    public let propellant1: String
    /// One of the two propellants used in the engine
    public let propellant2: String
    /// The thrust-to-weight ratio of the engine
    public let thrustToWeightRatio: Int

    enum CodingKeys: String, CodingKey {
        case isp
        case count = "number"
        case type
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }

    package init(
        isp: ISP,
        thrust: Thrust,
        count: Int,
        type: String,
        propellant1: String,
        propellant2: String,
        thrustToWeightRatio: Int
    ) {
        self.isp = isp
        self.thrust = thrust
        self.count = count
        self.type = type
        self.propellant1 = propellant1
        self.propellant2 = propellant2
        self.thrustToWeightRatio = thrustToWeightRatio
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isp = try container.decode(.isp)
        thrust = try .init(from: decoder) // defer decoding to ThrustDTO
        count = try container.decode(.count)
        type = try container.decode(.type)
        propellant1 = try container.decode(.propellant1)
        propellant2 = try container.decode(.propellant2)
        thrustToWeightRatio = try container.decodeInt(.thrustToWeight)
    }
}
