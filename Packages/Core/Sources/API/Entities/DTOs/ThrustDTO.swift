//
//  ThrustDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the thrust of an engine, in kN
public struct ThrustDTO: APIModel {
    /// The thrust of the engine at sea level
    let seaLevel: Measurement<UnitForce>
    /// The thrust of the engine in vacuum
    let vacuum: Measurement<UnitForce>

    enum CodingKeys: String, CodingKey {
        case thrustSeaLevel = "thrust_sea_level"
        case thrustVacuum = "thrust_vacuum"
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let seaLevelContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .thrustSeaLevel)
        let thrustSeaLevel: Int = try seaLevelContainer.decode("kN")
        let vacuumContainer = try container.nestedContainer(keyedBy: DynamicCodingKey.self, forKey: .thrustVacuum)
        let thrustVacuum: Int = try vacuumContainer.decode("kN")
        seaLevel = .init(value: Double(thrustSeaLevel), unit: .kiloNewton)
        vacuum = .init(value: Double(thrustVacuum), unit: .kiloNewton)
    }
}
