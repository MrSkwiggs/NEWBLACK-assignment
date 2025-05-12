//
//  RocketView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Shared

struct RocketView: View {

    let rocket: Rocket

    var body: some View {
        StickyHeaderList {
            AsyncGallery(images: rocket.imageURLs)
        } content: {
            Text(rocket.details)

            Section("Details") {
                LabeledContent {
                    Text(rocket.name)
                } label: {
                    Text("Name")
                }
                LabeledContent {
                    Text(rocket.type)
                } label: {
                    Text("Type")
                }
                LabeledContent {
                    Text(rocket.isActive ? "Active" : "Inactive")
                        .foregroundStyle(rocket.isActive ? .green : .red)
                } label: {
                    Text("Status")
                }
            }

            Section("Engines") {
                if let engines = rocket.engines {
                    HStack {
                        Text("\(engines.count)")
                            .monospacedDigit()
                        Text(Image(systemName: "multiply"))
                            .foregroundStyle(.secondary)
                        Text(engines.type)
                    }
                } else {
                    Text("No engines available")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(rocket.name)
    }
}

import Mocks
#Preview {
    RocketView(rocket: .kraken)
}
