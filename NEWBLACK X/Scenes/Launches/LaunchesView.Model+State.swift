//
//  LaunchesView.Model+State.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Entities
import Mocks

extension LaunchesView.Model {
    enum State {
        case loading(previousLaunches: [Launch])
        case loaded(launches: [Launch])
        case noContent
        case error

        mutating func add(launches: [Launch]) {
            if case let .loaded(previousLaunches) = self {
                set(launches: previousLaunches + launches)
            } else {
                set(launches: launches)
            }
        }

        private mutating func set(launches: [Launch]) {
            guard !launches.isEmpty else {
                self = .noContent
                return
            }
            self = .loaded(launches: launches)
        }

        mutating func setLoading() {
            let mocks: [Launch] = [
                .krakenUnleashed,
                .minmusMambo,
                .munaholicAchievement,
                .seaOfKerbalDebut
            ]
            switch self {
            case .loading(previousLaunches: _):
                break
            case .loaded(let launches):
                let launches = launches.isEmpty ? mocks : launches
                self = .loading(previousLaunches: launches)
            case .noContent:
                self = .loading(previousLaunches: mocks)
            case .error:
                self = .loading(previousLaunches: mocks)
            }
        }
    }
}
