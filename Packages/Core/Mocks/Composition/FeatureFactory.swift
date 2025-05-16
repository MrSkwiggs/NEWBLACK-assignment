//
//  FeatureFactory.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Shared
import Entities

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

    static func useMocks(
        with state: LaunchArgument.State,
        mockDuration: MockDuration = .oneSecond
    ) {
        switch state {
        case .empty:
            shared.filterProvider.register { @MainActor in
                MockFilterProvider.empty
            }
            shared.launchProvider.register { @MainActor in
                MockLaunchProvider.empty(mockDuration: mockDuration)
            }
            shared.rocketProvider.register { @MainActor in
                MockRocketProvider.empty(mockDuration: mockDuration)
            }
        case .failure:
            shared.filterProvider.register { @MainActor in
                MockFilterProvider.empty
            }
            shared.launchProvider.register { @MainActor in
                MockLaunchProvider.failure(mockDuration: mockDuration)
            }
            shared.rocketProvider.register { @MainActor in
                MockRocketProvider.failure(mockDuration: mockDuration)
            }
        case .success:
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
}
