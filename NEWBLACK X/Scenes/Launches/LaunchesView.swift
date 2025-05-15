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
            ForEach(model.launches) { launch in
                NavigationLink {
                    LaunchView(model: viewModelFactory.launchViewModel(for: launch))
                } label: {
                    Row(launch: launch)
                }
            }
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
            } else {
                if model.launches.isEmpty {
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
            }
        }
        .redacted(reason: model.showSkeleton ? [.placeholder] : [])
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
    }
}

import Mocks
#Preview {
    LaunchesView(model: .init(launchProvider: MockLaunchProvider.success(), filterProvider: MockFilterProvider.empty))
}

#Preview("Empty") {
    LaunchesView(model: .init(launchProvider: MockLaunchProvider.empty(), filterProvider: MockFilterProvider.empty))
}

#Preview("Error") {
    LaunchesView(model: .init(launchProvider: MockLaunchProvider.failure(), filterProvider: MockFilterProvider.empty))
}
