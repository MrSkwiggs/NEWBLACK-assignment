//
//  LaunchView+Identifiers.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import Foundation
import Entities

extension ViewIdentifiers {
    class Launch: ID {
        init(key: String) {
            super.init(file: "\(key)_Launch")
        }

        lazy var rocket = id("rocket")
        lazy var rocketPlaceholder = id("rocketPlaceholder")

        lazy var launchpad = id("launchpad")

        lazy var wikipediaLink = id("wikipediaLink")

        lazy var rocketSheet = id("rocketSheet")
        lazy var launchpadSheet = id("launchpadSheet")
        lazy var linkSheet = id("linkSheet")
    }
}
