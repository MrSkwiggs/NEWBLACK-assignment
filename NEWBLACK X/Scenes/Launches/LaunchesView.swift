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
    var upcomingLaunches: [Launch] = []

    @State
    var pastLaunches: [Launch] = []

    @State
    var startDate: Date = Date()

    @State
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)

    var body: some View {
        List {
            Section("Upcoming") {
                ForEach(upcomingLaunches) { launch in
                    NavigationLink {
                        LaunchView(launch: launch)
                    } label: {
                        Row(launch: launch)
                    }
                }
            }

            Section("Past") {
                ForEach(pastLaunches) { launch in
                    NavigationLink {
                        LaunchView(launch: launch)
                    } label: {
                        Row(launch: launch)
                    }
                }
            }
        }
        .toolbar {
            DateRangeToolbar(startDate: $startDate, endDate: $endDate)
        }
        .task {
            await withThrowingTaskGroup { group in
                group.addTask { @MainActor in
                    self.upcomingLaunches = try await API.Launches.upcoming().docs
                }
                group.addTask { @MainActor in
                    self.pastLaunches = try await API.Launches.past().docs
                }
            }
        }
    }
}

import Mocks

#Preview {
    LaunchesView()
}
