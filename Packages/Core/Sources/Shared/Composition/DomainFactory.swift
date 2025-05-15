//
//  DomainFactory.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Factory

/// A factory that provides shared domains for the app.
public final class DomainFactory: SharedContainer {
    public static let shared: DomainFactory = .init()
    public let manager: ContainerManager = .init()

    /// A date provider that provides the current date.
    public var dateProvider: Factory<DateProvider> {
        self {
            .main
        }
        .singleton
    }

    /// A key store that stores user preferences.
    public var userPreferenceStorage: Factory<KeyStore> {
        self {
            .userDefaults(suitePrefix: "dev.skwiggs.newblack-x")
        }
        .singleton
    }
}
