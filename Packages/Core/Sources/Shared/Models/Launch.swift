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
    public private(set) var mission: String
    /// The launch site name
    public private(set) var site: String
    /// The launch date
    public private(set) var date: Date
    /// Whether or not the launch was successful
    public private(set) var wasSuccessful: Bool
    /// A summary of the launch
    public private(set) var summary: String
    /// A link to the launch video
    public private(set) var videoURL: URL?
    /// Images of the launch
    public private(set) var imageURLs: [URL]

    @Relationship
    public var rocket: Rocket?

    package init(
        id: String,
        mission: String,
        launchSite: String,
        date: Date,
        wasSuccessful: Bool,
        summary: String,
        videoURL: URL? = nil,
        imageURLs: [URL] = [],
        rocket: Rocket? = nil
    ) {
        self.id = id
        self.mission = mission
        self.site = launchSite
        self.date = date
        self.wasSuccessful = wasSuccessful
        self.summary = summary
        self.videoURL = videoURL
        self.imageURLs = imageURLs
        self.rocket = rocket
    }
}
