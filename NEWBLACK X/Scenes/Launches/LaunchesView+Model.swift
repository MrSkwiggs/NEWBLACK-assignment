//
//  Model.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import SwiftUI
import Shared
import Entities

extension LaunchesView {
    @MainActor
    @Observable
    final class Model {

        private let launchProvider: LaunchProviding
        private let filterProvider: FilterProviding

        init(
            launchProvider: LaunchProviding,
            filterProvider: FilterProviding
        ) {
            self.launchProvider = launchProvider
            self.filterProvider = filterProvider

            self.filters = filterProvider.filters
            self.isFilterActive = filterProvider.isActive

            filtersSinceLastFetch = (isActive: filterProvider.isActive, filters: filterProvider.filters)
            refreshTask = Task {
                await refresh()
            }
        }

        var launches: [Launch] = []

        private var filtersSinceLastFetch: (isActive: Bool, filters: [DateRangeFilter])

        var filters: [DateRangeFilter] {
            didSet {
                filterProvider.filters = filters
            }
        }

        var isFilterActive: Bool {
            didSet {
                filterProvider.isActive = isFilterActive
            }
        }

        var showSkeleton: Bool = false
        var showDateRangeFilter: Bool = false

        var hasNextPage: Bool {
            page != nil
        }

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

        func userDidPressClearFilters() {
            isFilterActive = false

            refreshTask = Task {
                await refresh()
            }
        }

        func userDidUpdateFilters() {
            guard isFilterActive != filtersSinceLastFetch.isActive || filters != filtersSinceLastFetch.filters else {
                return
            }
            filtersSinceLastFetch = (isActive: isFilterActive, filters: filters)
            refreshTask = Task {
                await refresh()
            }
        }

        func refresh() async {
            showSkeleton = true
            defer { showSkeleton = false }
            self.launches = await fetchPage(0)
        }

        private func fetchNextPage() {
            pageTask = Task {
                guard let page else { return }
                self.launches.append(contentsOf: await fetchPage(page))
            }
        }

        private func fetchPage(_ page: Int) async -> [Launch] {
            do {
                let response = try await launchProvider.fetch(atPage: page, filters: filterProvider.isActive ? filters : [])
                self.page = response.nextPage
                return response.items
            } catch {
                print("Error fetching next page of launches: \(error)")
                return []
            }
        }
    }
}
