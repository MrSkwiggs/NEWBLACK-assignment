//
//  Rockets.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import Entities

extension Rocket: Mockable {
    public static let kraken: Rocket = .init(
        id: UUID().uuidString,
        name: "Kraken",
        type: "Experimental",
        isActive: true,
        mass: .init(value: 50000, unit: .kilograms),
        height: .init(value: 70, unit: .meters),
        diameter: .init(value: 10, unit: .meters),
        engines: .raptor(count: 37),
        successRate: 0.283,
        imageURLs: [URL(string: "https://imgur.com/DaCfMsj.jpg")!],
        description: "Meet the Kraken: a gravity-devouring behemoth that rips through orbits with all the subtlety of a barnacle-crusted squid. Equipped with next-gen thrusters and enough cargo space to haul an entire Mun colony—if they survive the ride. Side effects may include spontaneous disassembly and an existential crisis when you realize you just outran your parachute."
    )

    public static let falcon9 = Rocket(
        id: "R-falcon9",
        name: "Falcon 9 Comical Booster",
        type: "Orbital-class",
        isActive: true,
        mass: .init(value: 549054, unit: .kilograms),
        height: .init(value: 70, unit: .meters),
        diameter: .init(value: 3.7, unit: .meters),
        engines: .merlin(count: 9),
        successRate: 0.967,
        imageURLs: [URL(string: "https://imgur.com/falcon9.jpg")!],
        description: "The trusty Falcon 9: delivering satellites and shattered dreams with pinpoint precision. Features reusable first stage and occasional celebratory landings on drone ships."
    )

    public static let starship = Rocket(
        id: "R-starship",
        name: "Starship",
        type: "Super Heavy",
        isActive: false,
        mass: .init(value: 1335000, unit: .kilograms),
        height: .init(value: 120, unit: .meters),
        diameter: .init(value: 9, unit: .meters),
        engines: .raptor(count: 33),
        successRate: 0.0,
        imageURLs: [URL(string: "https://imgur.com/starship.jpg")!],
        description: "Starship: the stainless-steel giant that’s either our ticket to Mars or a spectacular firework show. Coming soon to an atmosphere near you."
    )

    public static var mocks: [Rocket] {
        [
            kraken,
            falcon9,
            starship
        ]
    }
}
