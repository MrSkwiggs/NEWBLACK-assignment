//
//  BaseTestCase.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import XCTest
import Entities
import Mocks

@MainActor
open class BaseTestCase: XCTestCase {

    private var app: XCUIApplication!

    open override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    open override func setUp() async throws {
        try await super.setUp()
        await MainActor.run {
            app = .init()
        }
    }

    open override func tearDown() {
        super.tearDown()
    }

    public func activate() {
        app.activate()
    }

    open func screenshot(name: String = #function) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = name
        add(attachment)
    }

    public func page<T: Page>(for identifiers: KeyPath<ViewIdentifiers, T.Identifiers>) -> T {
        .init(app: app, identifiers: identifiers, testCase: self)
    }
}

// MARK: - LaunchArgument
extension BaseTestCase {

    func launch(with arguments: [LaunchArgument] = [.state(.success), .loadDuration(0)]) {
        app.launchArguments = arguments.map { $0.rawValue }
        app.launch()
    }

    @discardableResult
    func navigateToHomePage(loadingDuration: Int = 0) -> HomePage {
        launch(with: [.state(.success), .loadDuration(loadingDuration)])
        activate()

        return HomePage(app: app, identifiers: \.home, testCase: self)
    }
}
