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
                Button {
                    sheetContent = .rocket("Falcon 9")
                } label: {
                    Text("Falcon 9")
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
        case rocket(String)

        var id: String {
            switch self {
            case .rocket(let name):
                return name
            }
        }

    }
}

#Preview {
    LaunchView(launch: .kittenSP)
}
