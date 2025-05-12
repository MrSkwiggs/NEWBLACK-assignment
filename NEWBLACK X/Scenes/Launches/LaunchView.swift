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
        StickyHeaderList {
            AsyncImage(url: launch.imageURLs.first) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
        } content: {
            Text(launch.summary)

            Section("Details") {
                LabeledContent {
                    Text(launch.mission)
                } label: {
                    Text("Mission")
                }
                LabeledContent {
                    Text(launch.date.formatted(date: .long, time: .shortened))
                } label: {
                    Text("Date")
                }
                LabeledContent {
                    if let url = launch.videoURL {
                        Link(destination: url) {
                            HStack {
                                Text("Watch on Youtube")
                                Image(systemName: "play.rectangle")
                            }
                        }
                    } else {
                        Text("No video available")
                    }
                } label: {
                    Text("Video")
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

    LaunchView(launch: .kerbalSP)
}
