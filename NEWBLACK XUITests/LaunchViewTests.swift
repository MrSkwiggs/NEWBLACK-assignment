//
//  LaunchViewTests.swift
//  NEWBLACK XUITests
//
//  Created by Dorian on 16/05/2025.
//

import XCTest

final class LaunchViewTests: BaseTestCase {

    func testLoadsRockets() {
        let launchPage = navigateToHomePage(loadingDuration: 1).launches.navigateToLaunch()

        XCTAssertTrue(launchPage.rocketPlaceholder.waitForNonExistence(timeout: 2), "Rocket Placeholder should disappear after initial load")
        XCTAssertTrue(launchPage.rocket.waitForExistence(timeout: 2), "Rocket should exist after initial load")
    }

    func testRocketSheet() {
        let launchPage = navigateToHomePage(loadingDuration: 0).launches.navigateToLaunch()

        XCTAssertTrue(launchPage.rocketSheet.waitForNonExistence(timeout: 2), "Rocket Sheet should not exist before tapping on Rocket")
        launchPage.rocket.tap()

        XCTAssertTrue(launchPage.rocketSheet.waitForExistence(timeout: 2), "Rocket Sheet should exist after tapping on Rocket")
    }

    func testLaunchpadSheet() {
        let launchPage = navigateToHomePage(loadingDuration: 0).launches.navigateToLaunch()
        
        XCTAssertTrue(launchPage.launchpadSheet.waitForNonExistence(timeout: 2), "Launchpad Sheet should not exist before tapping on Launchpad")
        launchPage.launchpad.tap()
        XCTAssertTrue(launchPage.launchpadSheet.waitForExistence(timeout: 2), "Launchpad Sheet should exist after tapping on Launchpad")
    }
}
