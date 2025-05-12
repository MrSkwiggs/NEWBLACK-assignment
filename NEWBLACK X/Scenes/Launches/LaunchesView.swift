//
//  LaunchesView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Shared
import SwiftData

struct LaunchesView: View {

    @Query
    var upcomingLaunches: [Launch]

    @Query
    var pastLaunches: [Launch]

    init() {
        let now = Date.now
        _upcomingLaunches = Query(filter: #Predicate<Launch> {
            $0.date > now
        }, sort: \.date, order: .reverse)
        _pastLaunches = Query(filter: #Predicate<Launch> {
            $0.date < now
        }, sort: \.date, order: .reverse)
    }

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
    }
}

import Mocks

#Preview {
    LaunchesView()
        .modelContainer(.previews)
}
