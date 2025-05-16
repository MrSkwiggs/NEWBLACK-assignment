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

        init(rocketProvider: RocketProviding) {
            self.rocketProvider = rocketProvider

            refreshTask = Task {
                await refresh()
            }
        }

        var state: ModelState<Rocket> = .loaded(items: [])

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

        func refresh() async {
            state.setLoading()
            await fetchPage(0)
        }

        private func fetchNextPage() {
            pageTask = Task {
                guard let page else { return }
                await fetchPage(page)
            }
        }

        private func fetchPage(_ page: Int) async {
            do {
                let response = try await rocketProvider.fetch(atPage: page)
                self.page = response.nextPage
                self.state.add(items: response.items)
            } catch {
                print("Error fetching rockets: \(error)")
                state = .error
            }
        }
    }
}
