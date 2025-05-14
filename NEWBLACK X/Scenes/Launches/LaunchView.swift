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
                    Text(launchStatusLabel)
                        .foregroundStyle(launchStatusColor)
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
                    if let rocket {
                        Button {
                            sheetContent = .rocket(rocket)
                        } label: {
                            Text(rocket.name)
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .task {
                                do {
                                    rocket = try await API.Rockets.fetch(byID: launch.rocketID)
                                } catch {
                                    print("Failed to fetch rocket: \(error)")
                                }
                            }
                    }
                } label: {
                    Text("Rocket")
                }

                LabeledContent {
                    Button {
                        sheetContent = .launchpad(launch.launchpad)
                    } label: {
                        Text(launch.launchpad.name)
                    }
                } label: {
                    Text("Launchpad")
                }
            }

            Section("Links") {
                if launch.links.hasLinks == false {
                    Text("No links available")
                        .foregroundStyle(.secondary)
                }

                if let url = launch.links.webcast {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "play.rectangle")
                            Text("Watch the launch")
                        }
                    }
                }

                if let url = launch.links.wikipedia {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "book")
                            Text("Read more")
                        }
                    }
                }
            }
        }
        .sheet(item: $sheetContent) { item in
            Group {
                switch item {
                case let .rocket(rocket):
                    RocketView(rocket: rocket)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)

                case let .launchpad(launchpad):
                    LaunchpadView(launchpad: launchpad)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }
            .stickyHeaderListStyle(.small)
        }
        .navigationTitle(launch.name)
    }

    var launchStatusLabel: String {
        if launch.isUpcoming {
            "Upcoming"
        } else {
            launch.isSuccess == true ? "Success" : "Failure"
        }
    }

    var launchStatusColor: Color {
        if launch.isUpcoming {
            return .yellow
        } else {
            return launch.isSuccess == true ? .green : .red
        }
    }

    @ViewBuilder
    var description: some View {
        if let failures = launch.failures, !failures.isEmpty {
            ForEach(failures, id: \.hashValue) { failure in
                VStack(alignment: .leading) {
                    Text("Failure at \(failure.time) seconds")
                        .foregroundStyle(.secondary)
                    if let altitude = failure.altitude {
                        Text("Altitude: \(altitude) km")
                            .foregroundStyle(.secondary)
                    }
                    Text("Reason: \(failure.reason)")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
        } else {
            if let details = launch.details {
                Text(details)
                    .foregroundStyle(.secondary)
                    .padding()
            } else {
                Text("No details available")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
    }
}

extension LaunchView {
    enum SheetPresentationContent: Identifiable {
        case rocket(Rocket)
        case launchpad(Launchpad)

        var id: String {
            switch self {
            case .rocket(let rocket):
                return rocket.id
            case .launchpad(let launchpad):
                return launchpad.id
            }
        }

    }
}

#Preview {

    LaunchView(launch: .minmusMambo)
}
