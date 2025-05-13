//
//  ISPDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the ISP (Specific Impulse) of an engine, in seconds
public struct ISPDTO: APIModel {
    /// The ISP of the engine at sea level, in seconds
    let seaLevel: Int
    /// The ISP of the engine in vacuum, in seconds
    let vacuum: Int

    enum CodingKeys: String, CodingKey {
        case seaLevel = "sea_level"
        case vacuum
    }
}
