//
//  LaunchView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import API

struct LaunchView: View {

    let launch: Launch

    @State
    private var rocket: Rocket?

    @State
    private var sheetContent: SheetPresentationContent?

    var body: some View {
        StickyHeaderList {
            AsyncGallery(images: launch.links.images) {
                HStack {
                    Text("Status:")
                        .foregroundStyle(.white.opacity(0.5))
                    Text(launch.isSuccess == true ? "Success" : "Failure")
                        .foregroundStyle(launch.isSuccess ?? false ? .green : .red)
                }
                .font(.caption)
                .bold()
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background {
                    Capsule().fill(.ultraThinMaterial)
                }
            }
        } content: {
            Text(launch.details ?? "No details available")

            Section("Details") {
                LabeledContent {
                    Text(launch.date.formatted(date: .long, time: .shortened))
                } label: {
                    Text("Date")
                }
                LabeledContent {
                    if let url = launch.links.webcast {
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
                if let rocket {
                    Button {
                        sheetContent = .rocket(rocket)
                    } label: {
                        RocketsView.Row(rocket: rocket)
                    }
                } else {
                    Text("No rocket available")
                        .task {
                            do {
                                rocket = try await API.Rockets.fetch(byID: launch.rocketID)
                            } catch {
                                print("Failed to fetch rocket: \(error)")
                            }
                        }
                }
            }
        }
        .sheet(item: $sheetContent) { item in
            switch item {
            case let .rocket(rocket):
                RocketView(rocket: rocket)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .navigationTitle(launch.name)
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

    LaunchView(launch: .minmusMambo)
}
