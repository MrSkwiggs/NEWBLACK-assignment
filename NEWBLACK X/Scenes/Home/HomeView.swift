//
//  HomeView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Launches", systemImage: "airplane.departure") {
                NavigationStack {
                    LaunchesView()
                }
            }
            Tab("Rockets", systemImage: "airplane") {
                NavigationStack {
                    RocketsView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
