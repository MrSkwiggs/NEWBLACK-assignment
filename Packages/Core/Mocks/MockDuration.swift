//
//  LoadingDuration.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

/// A type that conveniently allows to mock delays
public struct MockDuration : Sendable{
    let duration: Duration

    private init(seconds: Int) {
        self.duration = .seconds(seconds)
    }

    public func sleep() async {
        try? await Task.sleep(for: duration)
    }

    /// A loading duration of 0 seconds
    public static let instant: MockDuration = .init(seconds: 0)

    /// A loading duration of 1 second
    public static let oneSecond: MockDuration = .init(seconds: 1)

    /// A loading duration of 2 seconds
    public static let twoSeconds: MockDuration = .init(seconds: 2)

    /// A loading duration of 5 seconds
    public static let fiveSeconds: MockDuration = .init(seconds: 5)

    /// A loading duration of 60 seconds
    public static let minute: MockDuration = .init(seconds: 60)

    /// A loading duration of the given amount of seconds
    public static func seconds(_ seconds: Int) -> MockDuration { .init(seconds: seconds) }
}
