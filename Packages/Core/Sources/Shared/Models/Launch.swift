//
//  Launch.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import SwiftData

@Model
public final class Launch: Identifiable {
    /// The Launch ID
    @Attribute(.unique)
    public private(set) var id: String

    /// The Mission name
    public package(set) var mission: String
    /// The launch site name
    public package(set) var launchSite: String
    /// The launch date
    public package(set) var date: Date
    /// Whether or not the launch was successful
    public package(set) var wasSuccessful: Bool

    @Relationship
    public private(set) var rocket: Rocket?

    package init(
        id: String,
        mission: String,
        launchSite: String,
        date: Date,
        wasSuccessful: Bool,
        rocket: Rocket? = nil
    ) {
        self.id = id
        self.mission = mission
        self.launchSite = launchSite
        self.date = date
        self.wasSuccessful = wasSuccessful
        self.rocket = rocket
    }
}
