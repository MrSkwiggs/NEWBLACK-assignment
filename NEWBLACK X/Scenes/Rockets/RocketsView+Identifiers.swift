//
//  RocketsView+Identifiers.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import Foundation
import Entities

extension ViewIdentifiers {
    class Rockets: ID {
        init() {
            super.init(file: "Rockets")
        }
    }

    var rockets: Rockets { .init() }
}
