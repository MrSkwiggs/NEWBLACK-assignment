//
//  HomeView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

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
            }
            Tab("Rockets", systemImage: "airplane") {
                NavigationStack {
                    RocketsView(model: viewModelFactory.rocketsViewModel())
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
