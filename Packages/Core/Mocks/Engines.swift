//
//  Engines.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Shared

@MainActor
public extension Engines {
    static func raptor(count: Int) -> Engines {
        Engines(count: count, type: "Raptor")
    }
    static func merlin(count: Int) -> Engines {
        Engines(count: count, type: "Merlin")
    }
}
