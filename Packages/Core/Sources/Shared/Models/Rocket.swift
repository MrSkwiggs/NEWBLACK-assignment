//
//  Rocket.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import SwiftData

@Model
public final class Rocket: Identifiable {
    @Attribute(.unique)
    public private(set) var id: String

    public private(set) var imageURLs: [URL]
    public private(set) var name: String
    public private(set) var details: String
    public private(set) var isActive: Bool
    public private(set) var type: String
    public private(set) var successRate: Double

    @Relationship(deleteRule: .cascade)
    public var launches: [Launch]

    public private(set) var engines: Engines?

    package init(
        id: String,
        imageURLs: [URL],
        name: String,
        details: String,
        isActive: Bool,
        type: String,
        successRate: Double,
        launches: [Launch] = [],
        engines: Engines? = nil
    ) {
        self.id = id
        self.imageURLs = imageURLs
        self.name = name
        self.details = details
        self.isActive = isActive
        self.type = type
        self.successRate = successRate
        self.launches = launches
        self.engines = engines
    }
}
