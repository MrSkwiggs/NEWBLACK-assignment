//
//  ViewModelFactory.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import Factory
import SwiftUI
import Shared
import Entities

final class ViewModelFactory: ManagedContainer, ObservableObject {

    let manager: ContainerManager = .init()

    private var domains: DomainFactory { DomainFactory.shared }
    private var features: FeatureFactory { FeatureFactory.shared }

    var launchesViewModel: Factory<LaunchesView.Model> {
        self { @MainActor in
                .init(
                    launchProvider: self.features.launchProvider(),
                    filterProvider: self.features.filterProvider()
            )
        }
    }

    func launchViewModel(for launch: Launch) -> LaunchView.Model {
        self { @MainActor in
            LaunchView.Model(
                launch: launch,
                rocketProvider: self.features.rocketProvider()
            )
        }()
    }

    var rocketsViewModel: Factory<RocketsView.Model> {
        self { @MainActor in
            .init(rocketProvider: self.features.rocketProvider())
        }
    }
}

import Mocks
extension ViewModelFactory {
    static func mock(duration: MockDuration) -> ViewModelFactory {
        DomainFactory.useMocks()
        FeatureFactory.useMocks(mockDuration: duration)
        return .init()
    }
}
