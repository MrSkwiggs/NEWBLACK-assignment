//
//  FailureDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public struct FailureDTO: APIModel {
    public let time: Int
    public let altitude: Int?
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
