//
//  Launches+Latest.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Networking

public extension Launches {
    final class Latest: Launches, Request, @unchecked Sendable {
        public typealias Response = LaunchDTO

        public override var path: String {
            super.path + "/latest"
        }
    }
}
