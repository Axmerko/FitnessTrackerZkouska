//
//  FitnessTrackerApp.swift
//  FitnessTracker Watch App
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

@main
struct FitnessTracker_Watch_AppApp: App { // Název structu nech tak, jak ho tam máš
    // 1. Inicializace
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // 2. Vstříknutí
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
