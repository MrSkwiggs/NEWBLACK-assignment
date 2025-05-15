//
//  LaunchesView.Model+State.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Entities

extension LaunchesView.Model {
    enum State {
        case loading(previousLaunches: [Launch])
        case loaded(launches: [Launch])
        case noContent
        case error

        mutating func add(launches: [Launch]) {
            switch self {
            case .loading:
                if launches.isEmpty {
                    self = .noContent
                } else {
                    self = .loaded(launches: launches)
                }
            case .loaded(launches: let previousLaunches):
                self = .loaded(launches: previousLaunches + launches)
            case .noContent:
                self = .loaded(launches: launches)
            case .error:
                self = .loaded(launches: launches)
            }
        }

        mutating func setLoading() {
            switch self {
            case .loading(previousLaunches: _):
                break
            case .loaded(let launches):
                self = .loading(previousLaunches: launches)
            case .noContent:
                self = .loading(previousLaunches: [])
            case .error:
                self = .loading(previousLaunches: [])
            }
        }
    }
}
