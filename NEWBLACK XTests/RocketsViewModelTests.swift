//
//  RocketsViewModelTests.swift
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
@Suite("Rockets View Model Tests")
struct RocketsViewModelTests {

    @Test("Fetches launches on init")
    func fetchLaunchesOnInit() async {
        let expectFetchesOnInit = Expectation()

        let rocketProvider = MockRocketProvider.success(mockDuration: .instant, hookRockets: { page, willReturn in
            expectFetchesOnInit.fulfill()
            return willReturn
        })

        let model = RocketsView.Model(
            rocketProvider: rocketProvider
        )


        await Expectations(expectFetchesOnInit).fulfillment(within: .seconds(10))
    }

    @Test("Fetches pages")
    func fetchPages() async throws {
        let expectFetchesTwoPages = Expectation(expectedCount: 2)
        let expectedPages = [0, 1, 2]

        let rocketProvider = MockRocketProvider.success(mockDuration: .instant, hookRockets: { page, willReturn in
            expectFetchesTwoPages.fulfill()
            #expect(page == expectedPages[page])
            return willReturn
        })

        let model = RocketsView.Model(
            rocketProvider: rocketProvider
        )

        model.pageLoaderDidAppear()

        await Expectations(expectFetchesTwoPages).fulfillment(within: .seconds(10))
    }

}
