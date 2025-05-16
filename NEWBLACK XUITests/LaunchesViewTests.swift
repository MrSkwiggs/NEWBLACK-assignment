//
//  LaunchesViewTests.swift
//  NEWBLACK XUITests
//
//  Created by Dorian on 16/05/2025.
//

import XCTest

final class LaunchesViewTests: BaseTestCase {

    func testLoadsMorePages() {
        let launches = navigateToHomePage(loadingDuration: 3).launches
        XCTAssertTrue(
            launches.pageLoader.waitForNonExistence(timeout: 1),
            "Page Loader should disappear during refresh"
        )
        XCTAssertTrue(launches.pageLoader.waitForExistence(timeout: 3), "Page Loader should exist after initial load")
    }
}
