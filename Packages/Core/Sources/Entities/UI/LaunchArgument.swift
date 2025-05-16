//
//  LaunchArgument.swift
//  Core
//
//  Created by Dorian on 16/05/2025.
//

import Foundation

public enum LaunchArgument: Sendable, Codable, RawRepresentable {
    case loadDuration(Int)
    case state(State)

    public enum State: String, Sendable, Codable {
        case success
        case empty
        case failure
    }

    public init?(rawValue: RawValue) {
        if let state = State(rawValue: rawValue) {
            self = .state(state)
        } else if let duration = Int(rawValue) {
            self = .loadDuration(duration)
        } else {
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .loadDuration(let duration):
            return "\(duration)"
        case .state(let state):
            return state.rawValue
        }
    }
}
