//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

@main
struct FitnessTrackerApp: App {
    // 1. Inicializujeme náš controller
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Tady "vstříkneme" databázi do celé aplikace
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
