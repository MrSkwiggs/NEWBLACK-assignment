//
//  LaunchView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Entities

struct LaunchView: View {

    @State
    var model: Model

    var body: some View {
        StickyHeaderList {
            AsyncGallery(images: model.launch.links.images) {
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
            Text(model.launch.details ?? "No details available")

            Section("Details") {
                LabeledContent {
                    Text(model.launch.date.formatted(date: .long, time: .shortened))
                } label: {
                    Text("Date")
                }

                LabeledContent {
                    if let rocket = model.rocket {
                        Button {
                            model.userDidTapRocket(rocket)
                        } label: {
                            Text(rocket.name)
                        }
                        .elementIdentifier(\.launches.launch.rocket)
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .task {
                                model.viewDidAppear()
                            }
                            .elementIdentifier(\.launches.launch.rocketPlaceholder)
                    }
                } label: {
                    Text("Rocket")
                }

                LabeledContent {
                    Button {
                        model.userDidTapLaunchpad(model.launch.launchpad)
                    } label: {
                        Text(model.launch.launchpad.name)
                    }
                } label: {
                    Text("Launchpad")
                }
                .elementIdentifier(\.launches.launch.launchpad)
            }

            Section("Links") {
                if model.launch.links.hasLinks == false {
                    Text("No links available")
                        .foregroundStyle(.secondary)
                }

                if let url = model.launch.links.webcast {
                    Link(destination: url) {
                        HStack {
                            Image(systemName: "play.rectangle")
                            Text("Watch the launch")
                        }
                    }
                }

                if let url = model.launch.links.wikipedia {
                    Button {
                        model.userWantsToReadMore(at: url)
                    } label: {
                        HStack {
                            Image(systemName: "book")
                            Text("Read more")
                        }
                    }
                    .elementIdentifier(\.launches.launch.wikipediaLink)
                }
            }
        }
        .sheet(item: $model.sheetContent) { item in
            Group {
                switch item {
                case let .rocket(rocket):
                    RocketView(rocket: rocket)
                        .elementIdentifier(\.launches.launch.rocketSheet)
                case let .launchpad(launchpad):
                    LaunchpadView(launchpad: launchpad)
                        .elementIdentifier(\.launches.launch.launchpadSheet)
                case let .link(url):
                    WebView(url: url)
                        .ignoresSafeArea()
                        .elementIdentifier(\.launches.launch.linkSheet)
                }
            }
            .stickyHeaderListStyle(.small)
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .navigationTitle(model.launch.name)
        .rootIdentifier(\.launches.launch)
    }

    var launchStatusLabel: String {
        if model.launch.isUpcoming {
            "Upcoming"
        } else {
            model.launch.isSuccess == true ? "Success" : "Failure"
        }
    }

    var launchStatusColor: Color {
        if model.launch.isUpcoming {
            return .yellow
        } else {
            return model.launch.isSuccess == true ? .green : .red
        }
    }

    @ViewBuilder
    var description: some View {
        if let failures = model.launch.failures, !failures.isEmpty {
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
            if let details = model.launch.details {
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

extension LaunchView.Model {
    enum SheetContent: Identifiable {
        case rocket(Rocket)
        case launchpad(Launchpad)
        case link(URL)

        var id: String {
            switch self {
            case .rocket(let rocket):
                return rocket.id
            case .launchpad(let launchpad):
                return launchpad.id
            case .link(let url):
                return url.absoluteString
            }
        }

    }
}

#Preview {
//    LaunchView(launch: .minmusMambo)
}
