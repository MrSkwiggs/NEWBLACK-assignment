//
//  XCUIApp+Convenience.swift
//  NEWBLACK X
//
//  Created by Dorian on 16/05/2025.
//

import XCTest

public extension XCUIApplication {
    func descendants(matching identifier: String) -> [XCUIElement] {
        descendants(matching: .any).matching(identifier: identifier).allElementsBoundByIndex
    }

    func firstDescendant(matching identifier: String) -> XCUIElement {
        descendants(matching: .any).matching(identifier: identifier).firstMatch
    }
}

public extension XCUIElement {
    var hasFocus: Bool { value(forKey: "hasKeyboardFocus") as? Bool ?? false }

    var isTappable: Bool {
        exists && isHittable && isEnabled
    }
}

public extension XCTestCase {

    @MainActor
    func typeText(_ value: String, into element: XCUIElement) {
        element.tap()
        waitUntilElementHasFocus(element: element)
            .typeText(value)
    }

    @MainActor
    func waitUntilElementHasFocus(element: XCUIElement, timeout: TimeInterval = 20, file: StaticString = #file, line: UInt = #line) -> XCUIElement {
        element.tap()

        let expectation = expectation(description: "waiting for element \(element) to have focus")

        let timer = Timer(timeInterval: 1, repeats: true) { timer in
            let shouldInvalidate = MainActor.assumeIsolated {
                guard element.hasFocus else {
                    element.tap()
                    return false
                }

                expectation.fulfill()
                return true
            }

            if shouldInvalidate {
                timer.invalidate()
            }
        }

        RunLoop.current.add(timer, forMode: .common)

        wait(for: [expectation], timeout: timeout)

        return element
    }
}
