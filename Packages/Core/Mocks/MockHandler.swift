//
//  MockHandler.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

/// A handler that can dynamically perform operations with mocked delays
@dynamicCallable
public struct MockHandler: Sendable {
    let mockDuration: MockDuration

    public init(_ mockDuration: MockDuration) {
        self.mockDuration = mockDuration
    }

    public func dynamicallyCall<T: Sendable>(withArguments args: [() async throws -> T]) async throws -> T {
        await mockDuration.sleep()
        return try await args.first!()
    }

    public static let instant = MockHandler(.instant)
    public static let short = MockHandler(.short)
    public static let medium = MockHandler(.medium)
}
