//
//  LaunchesView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import SwiftData
import API

struct LaunchesView: View {

    @State
    var launches: [Launch] = []

    @State
    var page: Int? = 0

    @State
    var dateRanges: [DateRangeToolbar.Filter] = []

    @State
    var filterDateRanges: Bool = false

    var body: some View {
        List {
            ForEach(launches) { launch in
                NavigationLink {
                    LaunchView(launch: launch)
                } label: {
                    Row(launch: launch)
                }
            }
            if page != nil {
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .task {
                                await fetchNextPage()
                            }
                        Spacer()
                    }
                }
            } else {
                if launches.isEmpty {
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
                                dateRanges.removeAll()
                                filterDateRanges = false
                            }

                            Task {
                                await refresh()
                            }
                        }
                    }

                }
            }
        }
        .toolbar {
            DateRangeToolbar(isActive: $filterDateRanges, filters: $dateRanges) {
                Task {
                    await refresh()
                }
            }
        }
        .refreshable {
            await refresh()
        }
    }

    private func refresh() async {
        self.launches = await fetchPage(0)
    }

    private func fetchNextPage() async {
        guard let page else { return }
        self.launches.append(contentsOf: await fetchPage(page))
    }

    private func fetchPage(_ page: Int) async -> [Launch] {
        do {
            let ranges: Launch.Filter = .or(dateRanges.map {
                .range(field: .date, range: $0.range)
            })
            let response = try await API.Launches
                .query(
                    filter: filterDateRanges ? ranges : .empty,
                    populate: [.launchpad],
                    sort: [.by(.isUpcoming, .reverse), .by(.date, .reverse)],
                    page: page,
                    pageSize: 10
                )
            self.page = response.nextPage
            return response.items
        } catch {
            print("Error fetching next page of launches: \(error)")
            return []
        }
    }
}

import Mocks

#Preview {
    LaunchesView()
}
