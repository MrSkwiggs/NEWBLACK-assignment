//
//  LaunchesView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import SwiftData
import Entities
import Factory

struct LaunchesView: View {

    @EnvironmentObject
    var viewModelFactory: ViewModelFactory

    @State
    var model: Model

    var body: some View {
        List {
            switch model.state {
            case let .loading(previousLaunches):
                placeholders(for: previousLaunches)

            case let .loaded(launches):
                content(for: launches)

            case .noContent:
                noContent()

            case .error:
                error()
            }
        }
        .toolbar {
            DateRangeToolbar(
                isFilterActive: model.isFilterActive,
                showDateRangeFilter: $model.showDateRangeFilter
            ) {
                model.userDidPressClearFilters()
            }
        }
        .refreshable {
            await model.refresh()
        }
        .popover(isPresented: $model.showDateRangeFilter) {
            DateRangeFilterView(
                isActive: $model.isFilterActive,
                filters: $model.filters
            )
            .presentationDetents([.medium, .large])
            .onDisappear {
                model.userDidUpdateFilters()
            }
        }
        .animation(.default, value: model.isFilterActive)
        .rootIdentifier(\.launches)
    }

    @ViewBuilder
    private func placeholders(for launches: [Launch]) -> some View {
        rows(for: launches)
            .redacted(reason: .placeholder)
    }

    @ViewBuilder
    private func content(for launches: [Launch]) -> some View {
        rows(for: launches)
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
            .id(UUID())
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
            Text("No launches found matching your filters.")
        } actions: {
            Button("Clear Filters") {
                withAnimation {
                    model.userDidPressClearFilters()
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

    @ViewBuilder
    private func rows(for launches: [Launch]) -> some View {
        ForEach(launches) { launch in
            NavigationLink {
                LaunchView(model: viewModelFactory.launchViewModel(for: launch))
            } label: {
                Row(launch: launch)
            }
        }
    }
}

import Mocks
import Shared

#Preview {

    let factory = ViewModelFactory.mock(duration: .twoSeconds)

    NavigationStack {
        LaunchesView(model: factory.launchesViewModel())
    }
    .environmentObject(factory)
}

#Preview("Empty") {
    let factory = ViewModelFactory.mock(duration: .twoSeconds)

    NavigationStack {
        LaunchesView(model: .init(launchProvider: MockLaunchProvider.empty(), filterProvider: MockFilterProvider.empty))
    }
    .environmentObject(factory)
}

#Preview("Error") {
    NavigationStack {
        LaunchesView(model: .init(launchProvider: MockLaunchProvider.failure(), filterProvider: MockFilterProvider.empty))
    }
    .environmentObject(ViewModelFactory.mock(duration: .fiveSeconds))
}
