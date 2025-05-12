//
//  Rockets.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import Shared

@MainActor
public extension Rocket {
    static let kraken: Rocket = .init(
        id: UUID().uuidString,
        imageURLs: [.init(string: "https://imgur.com/DaCfMsj.jpg")!],
        name: "Kraken",
        details: "Meet the Kraken: a gravity-devouring behemoth that rips through orbits with all the subtlety of a barnacle-crusted squid. Equipped with next-gen thrusters and enough cargo space to haul an entire Mun colony—if they survive the ride. Side effects may include spontaneous disassembly and an existential crisis when you realize you just outran your parachute.",
        isActive: true,
        type: "Experimental",
        successRate: 0.283,
        engines: .raptor(count: 37)
    )

    static let jebsJoyride: Rocket = .init(
        id: UUID().uuidString,
        imageURLs: [],
        name: "Jeb's Joyride",
        details: "Specifically engineered for the bravest (or craziest) Kerbals. Guaranteed to get you to orbit... eventually. Parachute not included, but a signature Jebediah-style grin is guaranteed.",
        isActive: true,
        type: "Tourism",
        successRate: 0.73,
        engines: .merlin(count: 5)
    )

    static let mechjeb: Rocket = .init(
        id: UUID().uuidString,
        imageURLs: [],
        name: "MechJeb",
        details: "Fully autonomous rocket that promises precision landings, perfect orbits, and a backseat pilot that never sleeps. Side effects may include existential dread when you realize you've been riding a robot all along.",
        isActive: false,
        type: "Autonomous",
        successRate: 0.95,
        engines: .raptor(count: 3)
    )

    static let munWalker: Rocket = .init(
        id: UUID().uuidString,
        imageURLs: [],
        name: "Mun Walker",
        details: "A lander so reliable, you can practically take your shoes off and stroll on the Mun. Recommended for Kerbals with a taste for low-gravity sightseeing and minimal explosions.",
        isActive: true,
        type: "Lander",
        successRate: 0.88
    )

    static let dunaExpress: Rocket = .init(
        id: UUID().uuidString,
        imageURLs: [],
        name: "Duna Express",
        details: "High-speed transfer vehicle for those impatient to see red sands. Comes with optional heat shields and a complimentary existential crisis: 'Why am I here?'. Pods sold separately.",
        isActive: false,
        type: "Interplanetary",
        successRate: 0.62
    )
}
