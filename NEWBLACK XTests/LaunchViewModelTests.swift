//
//  LaunchViewModelTests.swift
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
@Suite("Launch View Model Tests")
struct LaunchViewModelTests {

    @Test("Fetches rocket on appear")
    func testFetchesRocketOnAppear() async throws {
        let expectFetchesRocket = Expectation()
        let expectedLaunch = Launch.krakenUnleashed

        let viewModel = LaunchView.Model(
            launch: expectedLaunch,
            rocketProvider: MockRocketProvider.success(hookRocket: { rocketID, result in
                #expect(rocketID == expectedLaunch.rocketID)
                expectFetchesRocket.fulfill()
                return result
            }),
        )

        viewModel.viewDidAppear()

        await Expectations(expectFetchesRocket).fulfillment(within: .seconds(10))
    }
}
