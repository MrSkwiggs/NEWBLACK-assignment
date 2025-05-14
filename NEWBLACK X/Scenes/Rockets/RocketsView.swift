//
//  RocketsView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import SwiftData
import API

struct RocketsView: View {

    @State
    var rockets: [Rocket] = []

    @State
    var page: Int? = 0

    var body: some View {
        List {
            ForEach(rockets) { rocket in
                NavigationLink {
                    RocketView(rocket: rocket)
                } label: {
                    Row(rocket: rocket)
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
        .refreshable {
            await refresh()
        }
    }

    private func refresh() async {
        self.rockets = await fetchPage(0)
    }

    private func fetchNextPage() async {
        guard let page else { return }
        self.rockets.append(contentsOf: await fetchPage(page))
    }

    private func fetchPage(_ page: Int) async -> [Rocket] {
        do {
            let response = try await API.Rockets
                .fetchAll(page: page)
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
    RocketsView(rockets: [.falcon9, .kraken])
}
