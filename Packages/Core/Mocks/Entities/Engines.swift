//
//  Engines.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Entities

public extension Engines {
    static func raptor(count: Int) -> Engines {
        .init(
            isp: .init(
                seaLevel: 330,
                vacuum: 380
            ),
            thrust: .init(
                seaLevel: .init(value: 1780, unit: .kiloNewton),
                vacuum: .init(value: 1960, unit: .kiloNewton)
            ),
            count: count,
            type: "Raptor",
            propellant1: "Methane",
            propellant2: "Liquid Oxygen",
            thrustToWeightRatio: 150
        )
    }

    static func merlin(count: Int) -> Engines {
        .init(
            isp: .init(
                seaLevel: 267,
                vacuum: 304
            ),
            thrust: .init(
                seaLevel: .init(value: 420, unit: .kiloNewton),
                vacuum: .init(value: 480, unit: .kiloNewton)
            ),
            count: count,
            type: "Merlin",
            propellant1: "RP-1 Kerosene",
            propellant2: "Liquid Oxygen",
            thrustToWeightRatio: 96
        )
    }
}
