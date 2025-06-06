//
//  ThrustDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the thrust of an engine, in kN
public struct Thrust: APIModel {
    /// The thrust of the engine at sea level
    public let seaLevel: Measurement<UnitForce>
    /// The thrust of the engine in vacuum
    public let vacuum: Measurement<UnitForce>

    package init(seaLevel: Measurement<UnitForce>, vacuum: Measurement<UnitForce>) {
        self.seaLevel = seaLevel
        self.vacuum = vacuum
    }

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
