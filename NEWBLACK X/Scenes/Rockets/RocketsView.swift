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

    var body: some View {
        List {
            ForEach(rockets) { rocket in
                NavigationLink {
                    RocketView(rocket: rocket)
                } label: {
                    Row(rocket: rocket)
                }
            }
        }
        .task {
            do {
                self.rockets = try await API.Rockets.fetchAll().docs
            } catch {
                print("Error fetching rockets: \(error)")
            }
        }
    }
}

import Mocks
#Preview {
    RocketsView(rockets: [.falcon9, .kraken])
}
