//
//  ISPDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the ISP (Specific Impulse) of an engine, in seconds
public struct ISP: APIModel {
    /// The ISP of the engine at sea level, in seconds
    public let seaLevel: Int
    /// The ISP of the engine in vacuum, in seconds
    public let vacuum: Int

    package init(seaLevel: Int, vacuum: Int) {
        self.seaLevel = seaLevel
        self.vacuum = vacuum
    }

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }
}
