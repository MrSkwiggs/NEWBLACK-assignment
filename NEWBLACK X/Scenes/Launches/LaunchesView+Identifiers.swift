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


    }

    var launches: Launches { .init() }
}
