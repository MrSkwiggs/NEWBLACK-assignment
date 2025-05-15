//
//  RocketsView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import SwiftData
import Entities

struct RocketsView: View {

    @State
    var model: Model

    var body: some View {
        List {
            ForEach(model.rockets) { rocket in
                NavigationLink {
                    RocketView(rocket: rocket)
                } label: {
                    Row(rocket: rocket)
                }
            }

            if model.hasNextPage {
                Section {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .task {
                                model.pageLoaderDidAppear()
                            }
                        Spacer()
                    }
                }
            }
        }
        .refreshable {
            await model.refresh()
        }
    }
}

import Mocks

#Preview {
    RocketsView(model: .init(rocketProvider: MockRocketProvider.success))
}
