//
//  Page.Launches+Launch.swift
//  NEWBLACK XUITests
//
//  Created by Dorian on 16/05/2025.
//

import XCTest
import Entities

extension LaunchesPage {
    class LaunchPage: BasePage<ViewIdentifiers.Launch> {
        var rocket: XCUIElement {
            app.firstDescendant(matching: identifiers.rocket)
        }

        var rocketPlaceholder: XCUIElement {
            app.firstDescendant(matching: identifiers.rocketPlaceholder)
        }

        var launchpad: XCUIElement {
            app.firstDescendant(matching: identifiers.launchpad)
        }

        var wikipediaLink: XCUIElement {
            app.firstDescendant(matching: identifiers.wikipediaLink)
        }

        var rocketSheet: XCUIElement {
            app.firstDescendant(matching: identifiers.rocketSheet)
        }

        var launchpadSheet: XCUIElement {
            app.firstDescendant(matching: identifiers.launchpadSheet)
        }

        var wikipediaSheet: XCUIElement {
            app.firstDescendant(matching: identifiers.linkSheet)
        }
    }
}
