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
        List {
            LabeledContent {
                Text(rocket.name)
            } label: {
                Text("Name")
            }
        }
        .navigationTitle(rocket.name)
    }
}

import Mocks
#Preview {
    RocketView(rocket: .kraken)
}
