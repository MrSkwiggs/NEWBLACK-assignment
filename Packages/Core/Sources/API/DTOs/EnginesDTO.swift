//
//  EnginesDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the engines of a rocket
public struct EnginesDTO: APIModel {
    /// The ISP of the engine
    let isp: ISPDTO
    /// The thrust of the engine
    let thrust: ThrustDTO
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
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
        case number
        case type
        case propellant1 = "propellant_1"
        case propellant2 = "propellant_2"
        case thrustToWeight = "thrust_to_weight"
    }
}
