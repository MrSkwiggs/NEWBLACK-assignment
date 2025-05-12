//
//  NEWBLACK_XApp.swift
//  NEWBLACK X
//

import SwiftUI
import SwiftData
import Shared

@main
struct NEWBLACK_XApp: App {

    var modelContainer: ModelContainer = {
        let schema = Schema([
            Launch.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(.previews)
    }
}
