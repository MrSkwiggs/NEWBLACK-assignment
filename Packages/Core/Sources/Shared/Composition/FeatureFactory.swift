//
//  FeatureFactory.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Factory

public final class FeatureFactory: SharedContainer {
    public static let shared: FeatureFactory = .init()
    public let manager: ContainerManager = .init()

    /// A filter provider that provides filters for the application.
    public var filterProvider: Factory<FilterProviding> {
        self { @MainActor in FilterProvider(store: DomainFactory.shared.userPreferenceStorage()) }
    }

    /// A Launch provider that provides launch information.
    public var launchProvider: Factory<LaunchProviding> {
        self { @MainActor in LaunchProvider() }
    }

    /// A Rocket provider that provides rocket information.
    public var rocketProvider: Factory<RocketProviding> {
        self { @MainActor in RocketProvider() }
    }
}
