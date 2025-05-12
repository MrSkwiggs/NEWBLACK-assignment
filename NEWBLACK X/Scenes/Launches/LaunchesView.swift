//
//  LaunchesView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct LaunchesView: View {
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
    }
}

#Preview {
    LaunchesView()
}
