//
//  Error.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

/// A mock error type used for testing/previewing purposes.
public enum MockError: String, Swift.Error, LocalizedError {
    /// A mock error
    case mock

    public var errorDescription: String? {
            """
            This mock is set to fail with an error - your code is working as expected.
            If you want to get rid of this error, try configuring your setup to show a success state instead.
            
            This is a default error type for mocks - check \(#file) for more info.
            """
    }
}
