//
//  NEWBLACK_XUITests.swift
//  NEWBLACK XUITests
//
//  Created by Dorian on 16/05/2025.
//

import XCTest

final class NEWBLACK_XUITests: BaseTestCase {

    func testLoadsMorePages() {
        let launches = navigateToHomePage(loadingDuration: 5).launches
        XCTAssertTrue(
            launches.pageLoader.waitForNonExistence(timeout: 4),
            "Page Loader should disappear during refresh"
        )
        XCTAssertTrue(launches.pageLoader.waitForExistence(timeout: 4), "Page Loader should exist after initial load")
    }
}
