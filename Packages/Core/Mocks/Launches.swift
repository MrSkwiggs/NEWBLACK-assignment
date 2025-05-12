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
        date: Date(timeIntervalSince1970: 1308898208),
        wasSuccessful: true
    )
    static let kerbalSP2: Launch = .init(
        id: UUID().uuidString,
        mission: "Kerbal Space Program 2",
        launchSite: "Unity",
        date: Date(timeIntervalSince1970: 1677138608),
        wasSuccessful: false
    )
    static let kittenSP: Launch = .init(
        id: UUID().uuidString,
        mission: "Kitten Space Program",
        launchSite: "BRUTAL",
        date: Date(timeIntervalSince1970: 1799740469),
        wasSuccessful: true
    )
}
