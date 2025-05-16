//
//  Launchpads.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation
import Entities

extension Launchpad: Mockable {
    public static let alpha = Launchpad(
        id: "P-Alpha",
        name: "KSC LC-39A",
        fullName: "Kerbin Space Center Launch Complex 39A",
        imageURLs: [URL(string: "https://example.com/ksc39a.jpg")!],
        details: "Originally built to send Kerbals to the Mun, now repurposed for routine hops.",
        status: .active,
        launchCount: 42
    )

    public static let omega = Launchpad(
        id: "P-Omega",
        name: "Oceanic Autonomous Deck",
        fullName: "Kerbin Offshore ASDS Platform",
        imageURLs: [URL(string: "https://example.com/asds.jpg")!],
        details: "Experimental floating platform. Turns out, water is still wet.",
        status: .active,
        launchCount: 3
    )

    public static let beta = Launchpad(
        id: "P-Beta",
        name: "KSC Runway 2",
        fullName: "Kerbin Space Center Airstrip & Rocketport",
        imageURLs: [URL(string: "https://example.com/runway2.jpg")!],
        details: "Dual-use runway for spaceplanes & rockets. Vibes: runway meets launch rail.",
        status: .retired,
        launchCount: 0
    )

    public static let delta = Launchpad(
        id: "P-Delta",
        name: "Hidden Boneyard Pad",
        fullName: "Secret Back-lot Launch Site",
        imageURLs: [URL(string: "https://example.com/boneyard.jpg")!],
        details: "Rumored to be haunted by retired boosters and confused engineers.",
        status: .retired,
        launchCount: 7
    )

    public static var mocks: [Launchpad] {
        return [alpha, omega, beta, delta]
    }
}
