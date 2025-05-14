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
    let isp: ISP
    /// The thrust of the engine
    let thrust: Thrust
    /// The number of engines
    let number: Int
    /// The type of the engine
    let type: String
    /// One of the two propellants used in the engine
    let propellant1: String
    /// One of the two propellants used in the engine
    let propellant2: String
    /// The thrust-to-weight ratio of the engine
    let thrustToWeightRatio: Int

    enum CodingKeys: String, CodingKey {
        case isp
        case number
        case type
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isp = try container.decode(.isp)
        thrust = try .init(from: decoder) // defer decoding to ThrustDTO
        number = try container.decode(.number)
        type = try container.decode(.type)
        propellant1 = try container.decode(.propellant1)
        propellant2 = try container.decode(.propellant2)
        thrustToWeightRatio = try container.decodeInt(.thrustToWeight)
    }
}
