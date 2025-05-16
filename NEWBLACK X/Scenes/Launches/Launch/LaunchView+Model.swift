//
//  Model.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import SwiftUI
import Shared
import Entities

extension LaunchView {
    @MainActor
    @Observable
    final class Model {
        private let rocketProvider: RocketProviding

        let launch: Launch
        var rocket: Rocket?

        var sheetContent: SheetContent?

        private var rocketTask: Task<Void, Never>?

        init(launch: Launch, rocketProvider: RocketProviding) {
            self.launch = launch
            self.rocketProvider = rocketProvider
        }

        func viewDidAppear() {
            rocketTask?.cancel()
            rocketTask = Task {
                do {
                    rocket = try await rocketProvider.fetch(rocketByID: launch.rocketID)
                } catch {
                    print("Failed to fetch rocket: \(error)")
                }
            }
        }

        func userDidTapRocket(_ rocket: Rocket) {
            sheetContent = .rocket(rocket)
        }

        func userDidTapLaunchpad(_ launchpad: Launchpad) {
            sheetContent = .launchpad(launchpad)
        }

        func userWantsToReadMore(at url: URL) {
            sheetContent = .link(url)
        }
    }
}
