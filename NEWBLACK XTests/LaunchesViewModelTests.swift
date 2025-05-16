//
//  NEWBLACK_XTests.swift
//  NEWBLACK XTests
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Testing
import TestingExpectation
@testable import NEWBLACK_X
import Shared
import Entities
import Mocks

@MainActor
@Suite("Launches View Model Tests")
struct LaunchesViewModelTests {
    @Test("Fetches launches on init")
    func fetchLaunchesOnInit() async {
        let expectFetchesOnInit = Expectation()

        let launchProvider = MockLaunchProvider.success(mockDuration: .instant) { page, filters, willReturn in
            expectFetchesOnInit.fulfill()
            return willReturn
        }

        let model = LaunchesView.Model(
            launchProvider: launchProvider,
            filterProvider: MockFilterProvider.empty
        )

        await Expectations(expectFetchesOnInit).fulfillment(within: .seconds(10))
    }

    @Test("Fetches pages")
    func fetchPages() async throws {
        let expectFetchesTwoPages = Expectation(expectedCount: 2)
        let expectedPages = [0, 1, 2]

        let launchProvider = MockLaunchProvider.success(mockDuration: .instant) { page, filters, willReturn in
            expectFetchesTwoPages.fulfill()
            #expect(page == expectedPages[page])
            return willReturn
        }

        let model = LaunchesView.Model(
            launchProvider: launchProvider,
            filterProvider: MockFilterProvider.empty
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            model.pageLoaderDidAppear()
        }

        await Expectations(expectFetchesTwoPages).fulfillment(within: .seconds(10))
    }

    @Test("Persists Filters")
    func persistsFilters() async throws {
        let filterProvider = MockFilterProvider.empty
        let expectedNewFilters: [DateRangeFilter] = [.init(range: Date()...Date())]
        let expectedIsActive = true

        let model = LaunchesView.Model(
            launchProvider: MockLaunchProvider.success(),
            filterProvider: filterProvider
        )

        #expect(model.filters == filterProvider.filters)
        #expect(model.isFilterActive == filterProvider.isActive)

        model.filters = expectedNewFilters
        model.isFilterActive = expectedIsActive

        #expect(filterProvider.filters == expectedNewFilters)
        #expect(filterProvider.isActive == expectedIsActive)
    }

    @Test("Fetches filters on init", arguments: zip(
        [
            [DateRangeFilter(range: Date()...Date())],
            [DateRangeFilter(range: Date()...Date()), DateRangeFilter(range: Date()...Date())],
            []
        ],
        [
            true,
            false,
            true
        ])
    )
    func fetchFiltersOnInit(expectedFilters: [DateRangeFilter], expectedIsActive: Bool) async throws {
        let filterProvider = MockFilterProvider(
            filters: expectedFilters,
            isActive: expectedIsActive
        )

        let model = LaunchesView.Model(
            launchProvider: MockLaunchProvider.success(),
            filterProvider: filterProvider
        )

        #expect(model.filters == expectedFilters)
        #expect(model.isFilterActive == filterProvider.isActive)
    }
}
