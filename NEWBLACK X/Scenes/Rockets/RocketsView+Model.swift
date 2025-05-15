//
//  Model.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import SwiftUI
import Shared
import Entities

extension RocketsView {
    @MainActor
    @Observable
    final class Model {
        private let rocketProvider: RocketProviding

        var rockets: [Rocket] = []

        @ObservationIgnored
        private var page: Int? = 0

        @ObservationIgnored
        private var refreshTask: Task<Void, Never>? {
            willSet {
                pageTask?.cancel()
            }
        }

        @ObservationIgnored
        private var pageTask: Task<Void, Never>?

        func pageLoaderDidAppear() {
            fetchNextPage()
        }

        var hasNextPage: Bool {
            page != nil
        }

        init(rocketProvider: RocketProviding) {
            self.rocketProvider = rocketProvider
            
            refreshTask = Task {
                await refresh()
            }
        }

        func refresh() async {
            self.rockets = await fetchPage(0)
        }

        private func fetchNextPage() {
            pageTask = Task {
                guard let page else { return }
                self.rockets.append(contentsOf: await fetchPage(page))
            }
        }

        private func fetchPage(_ page: Int) async -> [Rocket] {
            do {
                let response = try await rocketProvider.fetch(atPage: page)
                self.page = response.nextPage
                return response.items
            } catch {
                print("Error fetching next page of launches: \(error)")
                return []
            }
        }
    }
}
