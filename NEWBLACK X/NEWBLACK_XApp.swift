//
//  NEWBLACK_XApp.swift
//  NEWBLACK X
//

import SwiftUI
import SwiftData
import Shared
import Factory

@main
struct NEWBLACK_XApp: App {

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ViewModelFactory())
        }
    }
}
