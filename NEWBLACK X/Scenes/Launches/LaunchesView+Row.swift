//
//  LaunchesView+Row.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Shared

extension LaunchesView {
    struct Row: View {

        let launch: Launch

        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text(launch.mission)
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
                        Text(launch.launchSite)
                    }
                    LabelledCapsule {
                        if launch.wasSuccessful {
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Image(systemName: "xmark.circle.fill")
                        }
                    } label: {
                        Text(launch.wasSuccessful ? "Success" : "Failure")
                    }
                    .tint(launch.wasSuccessful ? .green : .red)
                }
                .tint(.secondary)
            }
        }
    }
}

import Mocks
#Preview {
    List {
        LaunchesView.Row(launch: .kerbalSP)
        LaunchesView.Row(launch: .kerbalSP2)
    }
    .preferredColorScheme(.dark)
}
