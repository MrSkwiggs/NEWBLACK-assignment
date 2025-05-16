//
//  LaunchArgumentFactory.swift
//  Core
//
//  Created by Dorian on 16/05/2025.
//

import Foundation
import Factory
import Entities

/// A factory that provides launch arguments based on the current process's arguments.
public final class LaunchArgumentFactory: SharedContainer {
    public static let shared: LaunchArgumentFactory = .init()
    public let manager: ContainerManager = .init()

    /// The launch arguments for the current process.
    public var launchArguments: Factory<[LaunchArgument]> {
        self {
            ProcessInfo.processInfo.arguments.compactMap({ LaunchArgument(rawValue: $0) })
        }
    }
}
