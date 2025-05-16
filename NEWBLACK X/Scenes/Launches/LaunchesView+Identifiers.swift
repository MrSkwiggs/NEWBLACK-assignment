//
//  LaunchesView+Identifiers.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import Foundation
import Entities

extension ViewIdentifiers {
    class Launches: ID {
        init() {
            super.init(file: "Launches")
        }

        lazy var row = id("row")
        lazy var pageLoader = id("pageLoader")
        
        lazy var launch: Launch = .init(key: key)
    }

    var launches: Launches { .init() }
}
