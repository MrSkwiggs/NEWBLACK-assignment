//
//  FailureDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public extension Launch {
    /// A structure representing a failure associated with a launch.
    struct Failure: APIModel {
        /// The time of the failure in seconds since the launch started.
        public let time: Int
        /// The altitude at which the failure occurred, in meters.
        public let altitude: Int?
        /// A description of the reason for the failure.
        public let reason: String

        public init(
            time: Int,
            altitude: Int?,
            reason: String
        ) {
            self.time = time
            self.altitude = altitude
            self.reason = reason
        }
    }
}
