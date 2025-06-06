//
//  Launches+Latest.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Networking
import Entities

public extension Launches {
    /// Latest Launch endpoint.
    final class Latest: Launches, Request, @unchecked Sendable {
        public typealias Response = Launch

        public override var path: String {
            super.path + "/latest"
        }
    }
}

public extension API.Launches {
    static func getLatest() async throws -> Launches.Latest.Response {
        try await API.shared.send(Launches.Latest())
    }
}
