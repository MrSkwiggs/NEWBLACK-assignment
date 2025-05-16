//
//  RocketView.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI
import Entities

struct RocketView: View {

    let rocket: Rocket

    @State
    var showISPDetails = false

    var body: some View {
        StickyHeaderList {
            AsyncGallery(images: rocket.imageURLs)
        } content: {
            Text(rocket.description)

            Section("Details") {
                LabeledContent {
                    Text(rocket.name)
                } label: {
                    Text("Name")
                }
                LabeledContent {
                    Text(rocket.type)
                } label: {
                    Text("Type")
                }
                LabeledContent {
                    Text(rocket.isActive ? "Active" : "Retired")
                        .foregroundStyle(rocket.isActive ? .green : .purple)
                } label: {
                    Text("Status")
                }
                LabeledContent {
                    Text(rocket.successRate, format: .percent)
                        .foregroundStyle(successRateColor)
                } label: {
                    Text("Success Rate")
                }
                LabeledContent {
                    Text(rocket.height.formatted())
                } label: {
                    Text("Height")
                }
                LabeledContent {
                    Text(rocket.diameter.formatted())
                } label: {
                    Text("Diameter")
                }
            }

            Section("Engines") {
                HStack {
                    Text("\(rocket.engines.count)")
                        .monospacedDigit()
                    Text(Image(systemName: "multiply"))
                        .foregroundStyle(.secondary)
                    Text(rocket.engines.type)
                }

                LabeledContent {
                    Button {
                        showISPDetails.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "water.waves")
                            Text("\(rocket.engines.isp.seaLevel) s")
                            Divider()
                            Text("\(rocket.engines.isp.vacuum) s")
                            Image(systemName: "circle.dashed")
                        }
                    }
                } label: {
                    Text("ISP")
                }

                LabeledContent {
                    HStack {
                        Image(systemName: "water.waves")
                        Text("\(rocket.engines.thrust.seaLevel.formatted())")
                        Divider()
                        Text("\(rocket.engines.thrust.vacuum.formatted())")
                        Image(systemName: "circle.dashed")
                    }
                } label: {
                    Text("Thrust")
                }

                LabeledContent {
                    Text("\(rocket.engines.thrustToWeightRatio.formatted())")
                } label: {
                    Text("Thrust-to-Weight Ratio")
                }

                LabeledContent {
                    Text("\(rocket.engines.propellant1.capitalized)")
                } label: {
                    Text("Propellant 1")
                }

                LabeledContent {
                    Text("\(rocket.engines.propellant2.capitalized)")
                } label: {
                    Text("Propellant 2")
                }
            }
        }
        .navigationTitle(rocket.name)
        .sheet(isPresented: $showISPDetails) {
            List {
                Text("**ISP** (Specific Impulse) is a measure of the efficiency of rocket engines. It indicates how much thrust is produced per unit of propellant consumed over time. The higher the ISP, the more efficient the engine is.")

                Section("ISP for this engine") {
                    LabeledContent {
                        Text("\(rocket.engines.isp.seaLevel) s")
                    } label: {
                        HStack {
                            Text(Image(systemName: "water.waves"))
                                .foregroundStyle(.secondary)
                            Text("Sea Level")
                        }
                    }

                    LabeledContent {
                        Text("\(rocket.engines.isp.vacuum) s")
                    } label: {
                        HStack {
                            Text(Image(systemName: "circle.dashed"))
                                .foregroundStyle(.secondary)
                            Text("Vacuum")
                        }
                    }
                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private var successRateColor: Color {
        Gradient.redToGreen
            .interpolateColor(at: rocket.successRate) ?? .secondary
    }
}

import Mocks
#Preview {
    RocketView(rocket: .kraken)
}
