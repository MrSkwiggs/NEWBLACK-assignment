//
//  DomainFactory.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Shared

public extension DomainFactory {
    /// Configures the domain factory to use mock implementations.
    static func useMocks() {
        shared.dateProvider.register {
            .mock(usingFixed: Date())
        }
        shared.userPreferenceStorage.register {
            .mock()
        }
    }
}
