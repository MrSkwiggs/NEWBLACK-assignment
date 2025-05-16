//
//  RocketsView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import SwiftData
import Entities

struct RocketsView: View {

    @State
    var model: Model

    var body: some View {
        List {
            switch model.state {
            case .loading(let previousRockets):
                placeholders(for: previousRockets)
            case .loaded(let rockets):
                content(for: rockets)
            case .noContent:
                noContent()
            case .error:
                error()
            }
        }
        .refreshable {
            await model.refresh()
        }
        .rootIdentifier(\.rockets)
    }

    @ViewBuilder
    private func placeholders(for rockets: [Rocket]) -> some View {
        rows(rockets)
            .redacted(reason: .placeholder)
    }

    @ViewBuilder
    private func content(for rockets: [Rocket]) -> some View {
        rows(rockets)
        if model.hasNextPage {
            Section {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .task {
                            model.pageLoaderDidAppear()
                        }
                    Spacer()
                }
            }

        }
    }

    @ViewBuilder
    private func noContent() -> some View {
        ContentUnavailableView {
            Label {
                Text("Nothing to see here")
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
            }
            .font(.headline)
        } description: {
            Text("No rockets found.")
        } actions: {
            Button("Retry") {
                Task {
                    await model.refresh()
                }
            }
        }
    }

    @ViewBuilder
    private func error() -> some View {
        ContentUnavailableView {
            Label {
                Text("An error occurred")
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
            }
            .font(.headline)
            .foregroundStyle(.red)
        } description: {
            Text("Please try again later.")
        } actions: {
            Button("Retry") {
                Task {
                    await model.refresh()
                }
            }
        }
    }

    private func rows(
        _ rockets: [Rocket]
    ) -> some View {
        ForEach(rockets) { rocket in
            NavigationLink {
                RocketView(rocket: rocket)
            } label: {
                Row(rocket: rocket)
            }
        }
    }
}

import Mocks

#Preview("Success") {

    let factory = ViewModelFactory.mock(duration: .twoSeconds)

    NavigationStack {
        RocketsView(model: factory.rocketsViewModel())
    }
    .environmentObject(factory)
}

#Preview("Empty") {
    NavigationStack {
        RocketsView(model: .init(rocketProvider: MockRocketProvider.empty(mockDuration: .twoSeconds)))
    }
}

#Preview("Error") {
    NavigationStack {
        RocketsView(model: .init(rocketProvider: MockRocketProvider.failure(mockDuration: .twoSeconds)))
    }
}
