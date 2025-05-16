//
//  HomeView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Entities

struct HomeView: View {

    @EnvironmentObject
    var viewModelFactory: ViewModelFactory

    var body: some View {
        TabView {
            Tab("Launches", systemImage: "airplane.departure") {
                NavigationStack {
                    LaunchesView(
                        model: viewModelFactory.launchesViewModel()
                    )
                }
                .elementIdentifier(\.home.launchesTab)
            }
            Tab("Rockets", systemImage: "airplane") {
                NavigationStack {
                    RocketsView(model: viewModelFactory.rocketsViewModel())
                }
                .elementIdentifier(\.home.rocketsTab)
            }
        }
        .rootIdentifier(\.home)
    }
}

#Preview {
    HomeView()
}
