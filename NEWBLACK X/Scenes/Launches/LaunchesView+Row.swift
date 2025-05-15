//
//  LaunchesView+Row.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Entities

extension LaunchesView {
    struct Row: View {

        let launch: Launch

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(launch.name)
                    .font(.headline)

                HStack {
                    LabelledCapsule {
                        Image(systemName: "calendar.circle.fill")
                    } label: {
                        Text(launch.date.formatted(date: .numeric, time: .omitted))
                    }
                    LabelledCapsule {
                        Image(systemName: "mappin.and.ellipse.circle.fill")
                    } label: {
                        Text(launch.launchpad.name)
                    }
                    LabelledCapsule {
                        launchStatusImage
                    } label: {
                        Text(launchStatusText)
                    }
                    .tint(launchStatusTint)
                }
                .tint(.secondary)
            }
        }

        @ViewBuilder
        var launchStatusImage: some View {
            if let isSuccess = launch.isSuccess {
                if isSuccess {
                    Image(systemName: "checkmark.circle.fill")
                } else {
                    Image(systemName: "xmark.circle.fill")
                }
            } else {
                Image(systemName: "questionmark.circle.fill")
            }
        }

        var launchStatusText: String {
            if let isSuccess = launch.isSuccess {
                return isSuccess ? "Success" : "Failure"
            } else {
                return "Upcoming"
            }
        }

        var launchStatusTint: Color {
            if let isSuccess = launch.isSuccess {
                return isSuccess ? .green : .red
            } else {
                return .yellow
            }
        }
    }
}

import Mocks
#Preview {
    List {
        LaunchesView.Row(launch: .minmusMambo)
        LaunchesView.Row(launch: .seaOfKerbalDebut)
        LaunchesView.Row(launch: .munaholicAchievement)
    }
    .preferredColorScheme(.dark)
}
