//
//  ModelContainer.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Shared
import SwiftData

@MainActor
public extension ModelContainer {
    static var previews: ModelContainer {
        let schema = Schema([
            Launch.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            let context = container.mainContext

            context.insert(Launch.kerbalSP)
            context.insert(Launch.kerbalSP2)
            context.insert(Launch.kittenSP)

            context.insert(Rocket.kraken)
            context.insert(Rocket.dunaExpress)
            context.insert(Rocket.jebsJoyride)
            context.insert(Rocket.mechejeb)
            context.insert(Rocket.munWalker)

            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }
}
