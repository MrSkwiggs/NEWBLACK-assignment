//
//  Page+Home.swift
//  NEWBLACK XUITests
//
//  Created by Dorian on 16/05/2025.
//

import XCTest
import Entities

class HomePage: BasePage<ViewIdentifiers.Home> {
    var launchesTab: XCUIElement {
        app.tabs[identifiers.launchesTab]
    }
    var rocketsTab: XCUIElement {
        app.tabs[identifiers.rocketsTab]
    }

    var launches: LaunchesPage {
        .init(app: app, identifiers: \.launches, testCase: testCase)
    }
}
