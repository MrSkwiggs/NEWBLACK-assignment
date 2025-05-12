//
//  RocketsView+Row.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Shared

extension RocketsView {
    struct Row: View {

        let rocket: Rocket

        var body: some View {
            HStack {
                AsyncImage(url: rocket.imageURLs.first) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .fill(.quinary)
                        ProgressView()
                    }
                }
                .frame(maxWidth: 50, maxHeight: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 12) {
                    Text(rocket.name)
                        .font(.headline)

                    HStack {
                        LabelledCapsule {
                            Image(systemName: "bolt.circle.fill")
                        } label: {
                            Text(rocket.type)
                        }
                        LabelledCapsule {
                            Image(systemName: "target")
                        } label: {
                            Text(rocket.successRate, format: .percent)
                        }
                        .tint(successRateColor)
                    }
                    .tint(.secondary)
                }
            }
        }

        private var successRateColor: Color {
            [Color.red, .orange, .green]
                .interpolateColor(at: rocket.successRate) ?? .secondary
        }
    }
}

import Mocks
#Preview {
    List {
        RocketsView.Row(rocket: .kraken)
    }
}
