//
//  Factory.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Factory

public final class DomainFactory: SharedContainer {
    public static let shared: DomainFactory = .init()
    public let manager: ContainerManager = .init()


    public var dateProvider: Factory<DateProvider> {
        self { .main }
    }
}
