//
//  LaunchView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Shared

struct LaunchView: View {

    let launch: Launch

    @State
    private var sheetContent: SheetPresentationContent?

    var body: some View {
        List {
            Section("Details") {
                LabeledContent {
                    Text(launch.mission)
                } label: {
                    Text("Mission")
                }
            }

            Section("Rocket") {
                if let rocket = launch.rocket {

                    Button {
                        sheetContent = .rocket(rocket)
                    } label: {
                        RocketsView.Row(rocket: rocket)
                    }
                } else {
                    Text("No rocket available")
                }
            }
        }
        .sheet(item: $sheetContent) { item in
            switch item {
            case let .rocket(name):
                RocketView(rocket: name)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationTitle(launch.mission)
    }
}

extension LaunchView {
    enum SheetPresentationContent: Identifiable {
        case rocket(Rocket)

        var id: String {
            switch self {
            case .rocket(let rocket):
                return rocket.id
            }
        }

    }
}

#Preview {
    var launch: Launch = {
        var launch: Launch = .kittenSP
        launch.rocket = .kraken
        return launch
    }()

    LaunchView(launch: launch)
}
