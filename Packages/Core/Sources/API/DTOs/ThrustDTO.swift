//
//  ThrustDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that represents the thrust of an engine, in kN
public struct ThrustDTO: APIModel {
    /// The thrust of the engine at sea level, in kN
    let seaLevel: Int
    /// The thrust of the engine in vacuum, in kN
    let vacuum: Int
}
