//
//  Page.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import XCTest
import Entities

@MainActor
public protocol Page {
    associatedtype Identifiers: ViewIdentifiersProviding

    var app: XCUIApplication { get }
    var view: XCUIElement { get }
    var testCase: BaseTestCase { get }

    init(app: XCUIApplication, identifiers: KeyPath<ViewIdentifiers, Identifiers>, testCase: BaseTestCase)
}

open class BasePage<Identifiers: ViewIdentifiersProviding>: Page {
    public let app: XCUIApplication
    public let identifiers: Identifiers
    public let testCase: BaseTestCase

    public required init(app: XCUIApplication, identifiers: KeyPath<ViewIdentifiers, Identifiers>, testCase: BaseTestCase) {
        self.app = app
        self.identifiers = ViewIdentifiers.main[keyPath: identifiers]
        self.testCase = testCase
    }

    public var view: XCUIElement {
        app.firstDescendant(matching: identifiers.root)
    }

    public func checkForExistence() -> Bool {
        view.exists
    }

    public func waitForExistence(timeout: TimeInterval = 5) -> Bool {
        view.waitForExistence(timeout: timeout)
    }

    public func waitForNonExistence(timeout: TimeInterval = 5) -> Bool {
        view.waitForNonExistence(timeout: timeout)
    }
}
