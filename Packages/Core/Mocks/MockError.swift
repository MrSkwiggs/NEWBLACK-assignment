//
//  Error.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

/// A mock error to be used in previews & tests
struct MockError: Swift.Error, LocalizedError, CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
            """
            You are using a mocked object, and this mock is set to fail with an error - your code is working as expected.
            If you want to get rid of this error, try configuring your tests/previews to show a success state instead.
            
            This is a default error type for mocks - check \(#file) for more info.
            """
    }

    public var description: String {
        debugDescription
    }

    public var errorDescription: String? {
        debugDescription
    }
}
