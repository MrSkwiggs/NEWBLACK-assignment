//
//  RocketsView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import SwiftData
import Shared

struct RocketsView: View {

    @Query
    var rockets: [Rocket]

    var body: some View {
        List {
            ForEach(rockets) { rocket in
                NavigationLink(rocket.name) {
                    RocketView(rocket: "Rocket \(rocket)")
                }
            }
        }
    }
}

import Mocks
#Preview {
    RocketsView()
        .modelContainer(.previews)
}
