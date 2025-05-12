//
//  Launches.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import Shared

@MainActor
public extension Launch {
    static let kerbalSP: Launch = .init(
        id: UUID().uuidString,
        mission: "Kerbal Space Program",
        launchSite: "Unity",
        date: Date(timeIntervalSince1970: 1_308_898_208),
        wasSuccessful: true,
        summary: "First fully reusable test flight of the Kerbal Mk.I rocket. Achieved stable orbit around Mun before safe reentry.",
        videoURL: URL(string: "https://youtu.be/AtmtP4vouSY"),
        imageURLs: ["https://live.staticflickr.com/65535/51676939646_1a12780e54_o.jpg",
                    "https://live.staticflickr.com/65535/51677186188_e03e87ae8e_o.jpg",
                    "https://live.staticflickr.com/65535/51676136297_0bbb893f44_o.jpg",
                    "https://live.staticflickr.com/65535/51677822295_87c2ee94b1_o.jpg",
                    "https://live.staticflickr.com/65535/51677186098_12c8f54593_o.jpg",
                    "https://live.staticflickr.com/65535/51676136282_5118fa42ef_o.jpg"].compactMap { URL(string: $0) },
        rocket: .kraken
    )

    static let kerbalSP2: Launch = .init(
        id: UUID().uuidString,
        mission: "Kerbal Space Program 2",
        launchSite: "Unity",
        date: Date(timeIntervalSince1970: 1_677_138_608),
        wasSuccessful: false,
        summary: "Second-generation launch aimed at deep-space trajectory. Engine anomaly during second-stage burn led to mission abort.",
        rocket: .jebsJoyride
    )

    static let kittenSP: Launch = .init(
        id: UUID().uuidString,
        mission: "Kitten Space Program",
        launchSite: "BRUTAL",
        date: Date(timeIntervalSince1970: 1_799_740_469),
        wasSuccessful: true,
        summary: "Innovative CubeSat mission carrying live kittens to test zero-G life support. All systems nominal, returned safely.",
        rocket: .dunaExpress
    )

    static let novaXPress: Launch = .init(
        id: UUID().uuidString,
        mission: "Nova X Press",
        launchSite: "Cape Novel",
        date: Date(timeIntervalSince1970: 1_602_414_400),
        wasSuccessful: true,
        summary: "Rapid-response resupply to orbital station Nova-3. Demonstrated ultra-fast turnaround between missions.",
        rocket: .mechjeb
    )

    static let redDawn: Launch = .init(
        id: UUID().uuidString,
        mission: "Red Dawn Probe",
        launchSite: "Red Rock Plateau",
        date: Date(timeIntervalSince1970: 1_721_200_000),
        wasSuccessful: false,
        summary: "Deep-space probe intended for Mars surface sample return. Lost telemetry after cruise phase, vehicle presumed lost.",
        rocket: .munWalker
    )
}
