//
//  NEWBLACK_XApp.swift
//  NEWBLACK X
//

import SwiftUI
import SwiftData
import Shared
import Factory

@main
struct NEWBLACK_XApp: App {

    @StateObject
    var viewModelFactory: ViewModelFactory

    init() {
    #if DEBUG
        _viewModelFactory = .init(wrappedValue: Self.debugViewModelFactory())
    #else
        _viewModelFactory = .init(wrappedValue: ViewModelFactory())
    #endif
    }

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(viewModelFactory)
        }
    }
}

import Mocks
import Entities

private extension NEWBLACK_XApp {
    static func debugViewModelFactory() -> ViewModelFactory {
        let arguments = LaunchArgumentFactory.shared.launchArguments()
        guard !arguments.isEmpty else {
            return ViewModelFactory()
        }

        let loadDuration = getMockDuration(from: arguments)
        let state = getState(from: arguments)
        return .mock(for: state, with: loadDuration)
    }

    static func getMockDuration(from arguments: [LaunchArgument]) -> MockDuration {
        for argument in arguments {
            if case .loadDuration(let duration) = argument {
                return .seconds(duration)
            }
        }
        return .instant
    }

    static func getState(from arguments: [LaunchArgument]) -> LaunchArgument.State {
        for argument in arguments {
            if case .state(let state) = argument {
                return state
            }
        }
        return .success
    }
}
