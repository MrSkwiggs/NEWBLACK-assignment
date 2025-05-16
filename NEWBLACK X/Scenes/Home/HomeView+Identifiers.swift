//
//  HomeView+Identifiers.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import Foundation
import Entities

extension ViewIdentifiers {
    class Home: ID {
        init() {
            super.init(file: "HomeView")
        }

        lazy var launchesTab: String = "launchesTab"
        lazy var rocketsTab: String = "rocketsTab"

        lazy var launches: Launches = .init()
        lazy var rockets: Rockets = .init()
    }

    var home: Home { .init() }
}
