//
//  Rocket.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import SwiftData

@Model
public final class Rocket {
    @Attribute(.unique)
    public private(set) var id: String

    public package(set) var imageURLs: [URL]
    public package(set) var name: String
    public package(set) var details: String
    public package(set) var active: Bool
    public package(set) var type: String
    public package(set) var successRate: Double

    package init(
        id: String,
        imageURLs: [URL],
        name: String,
        details: String,
        active: Bool,
        type: String,
        successRate: Double
    ) {
        self.id = id
        self.imageURLs = imageURLs
        self.name = name
        self.details = details
        self.active = active
        self.type = type
        self.successRate = successRate
    }
}
