//
//  FeatureFactory.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Shared

public extension FeatureFactory {
    /// Configures the factory to use mock implementations.
    static func useMocks(mockDuration: MockDuration = .oneSecond) {
        shared.filterProvider.register { @MainActor in
            MockFilterProvider.two
        }

        shared.launchProvider.register { @MainActor in
            MockLaunchProvider.success(mockDuration: mockDuration)
        }

        shared.rocketProvider.register { @MainActor in
            MockRocketProvider.success(mockDuration: mockDuration)
        }
    }
}
