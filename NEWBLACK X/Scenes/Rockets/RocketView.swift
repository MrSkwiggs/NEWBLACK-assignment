//
//  RocketView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct RocketView: View {

    let rocket: String

    var body: some View {
        Text("Rocket: \(rocket)")
            .navigationTitle(rocket)
    }
}

#Preview {
    RocketView(rocket: "Falcon 9")
}
