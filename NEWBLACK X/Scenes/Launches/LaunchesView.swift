//
//  LaunchesView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct LaunchesView: View {

    @State
    var startDate: Date = Date()

    @State
    var endDate: Date = Date().addingTimeInterval(60 * 60 * 24 * 7)

    var body: some View {
        List {
            Section("Upcoming") {
                ForEach(0..<5) { launch in
                    NavigationLink("Upcoming Launch \(launch)") {
                        LaunchView(launch: "Upcoming Launch \(launch)")
                    }
                }
            }

            Section("Past") {
                ForEach(0..<10) { launch in
                    NavigationLink("Past Launch \(launch)") {
                        LaunchView(launch: "Past Launch \(launch)")
                    }
                }
            }
        }
        .toolbar {
            DateRangeToolbar(startDate: $startDate, endDate: $endDate)
        }
    }
}

#Preview {
    LaunchesView()
}
