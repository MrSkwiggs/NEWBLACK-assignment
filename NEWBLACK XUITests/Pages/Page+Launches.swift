//
//  Page+Launches.swift
//  NEWBLACK XUITests
//
//  Created by Dorian on 16/05/2025.
//

import XCTest
import Entities

class LaunchesPage: BasePage<ViewIdentifiers.Launches> {

    var launchRows: [XCUIElement] {
        app.descendants(matching: identifiers.row)
    }

    var pageLoader: XCUIElement {
        app.firstDescendant(matching: identifiers.pageLoader)
    }

    var launch: LaunchPage {
        .init(app: app, identifiers: \.launches.launch, testCase: testCase)
    }

    @discardableResult
    func navigateToLaunch() -> LaunchPage {
        guard let row = launchRows.first else {
            XCTFail("Launch row not found")
            return launch
        }
        row.tap()
        return launch
    }
}

