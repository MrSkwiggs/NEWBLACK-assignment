//
//  LaunchpadView.swift
//  NEWBLACK X
//
//  Created by Dorian on 14/05/2025.
//

import SwiftUI
import Entities

struct LaunchpadView: View {
    let launchpad: Launchpad

    var body: some View {
        StickyHeaderList {
            AsyncGallery(images: launchpad.imageURLs)
        } content: {
            Text(launchpad.name)
                .bold()
            Text(launchpad.fullName)

            Section {
                Text(launchpad.details)
                LabeledContent {
                    Text(launchpad.launchCount.description)
                } label: {
                    Text("Launches")
                }
                LabeledContent {
                    Text(launchpad.status.rawValue)
                        .foregroundStyle(launchpad.status == .active ? .green : .purple)
                } label: {
                    Text("Status")
                }
            }
        }
    }
}

import Mocks
#Preview {
    NavigationStack {
        LaunchpadView(launchpad: .omega)
    }
}
