//
//  Launches.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import Entities

nonisolated(unsafe) private let isoFormatter = ISO8601DateFormatter()

extension Launch: Mockable {
    public static let munaholicAchievement = Launch(
        id: "L-001",
        date: isoFormatter.date(from: "2023-04-12T09:15:00Z")!,
        isUpcoming: false,
        name: "Munaholic Achievement",
        launchpad: .alpha,
        links: .munaholic,
        rocketID: "Falcon9-KSP",
        isSuccess: true,
        failures: nil,
        details: "Jebediah Kerman nailed his precision landing within 10 meters of the planting flag. 👏"
    )

    public static let seaOfKerbalDebut = Launch(
        id: "L-002",
        date: isoFormatter.date(from: "2024-11-05T18:30:00Z")!,
        isUpcoming: false,
        name: "Sea of Kerbal Debut",
        launchpad: .beta,
        links: .splashdown,
        rocketID: "FalconHeavy-KSP",
        isSuccess: false,
        failures: [
            Failure(time: 420, altitude: 12000, reason: "Grid fins malfunction—vehicle pirouetted into the briny deep")
        ],
        details: "Big props to Bob Kerman for waving at the cameras as we sank gracefully. 🚢💥"
    )

    public static let minmusMambo = Launch(
        id: "L-003",
        date: isoFormatter.date(from: "2025-07-01T14:00:00Z")!,
        isUpcoming: true,
        name: "Minmus Mambo Extravaganza",
        launchpad: .delta,
        links: .none,
        rocketID: "Starship-KSP",
        isSuccess: nil,
        failures: nil,
        details: "Payload: 100 kilos of Jeb’s leftover Mun samples + inflatable dance floor for Minmus surface boogie."
    )

    public static let krakenUnleashed = Launch(
        id: "L-004",
        date: isoFormatter.date(from: "2024-02-29T00:00:00Z")!,
        isUpcoming: false,
        name: "Kraken Unleashed",
        launchpad: .omega,
        links: .kraken,
        rocketID: "Falcon1-KSP",
        isSuccess: false,
        failures: [
            Failure(time: 15, altitude: 100, reason: "Fuel piping vacuum greed attracted literal Kraken tentacles"),
            Failure(time: 15, altitude: 100, reason: "Kraken detached booster mid-liftoff")
        ],
        details: "Turns out, don’t mix leftover fuel from Jool missions with standard kerosene. Lesson learned the hard way."
    )

    public static var mocks: [Launch] {
        [
            munaholicAchievement,
            seaOfKerbalDebut,
            minmusMambo,
            krakenUnleashed
        ]
    }
}
