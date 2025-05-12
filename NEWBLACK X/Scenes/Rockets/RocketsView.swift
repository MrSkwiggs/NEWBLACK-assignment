//
//  RocketsView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct RocketsView: View {
    var body: some View {
        List {
            ForEach(0..<10) { index in
                NavigationLink("Rocket \(index)") {
                    RocketView(rocket: "Rocket \(index)")
                }
            }
        }
    }
}

#Preview {
    RocketsView()
}
