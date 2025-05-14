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
    var startDate: Date = Date()

    @State
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)

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
            }
        }
        .toolbar {
            DateRangeToolbar(startDate: $startDate, endDate: $endDate)
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
            let response = try await API.Launches
                .query(
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
