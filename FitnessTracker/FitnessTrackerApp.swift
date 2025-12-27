//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI
import CoreData

@main
struct FitnessTrackerApp: App {
    let persistenceController = PersistenceController.shared
    
    // Inicializace konektoru
    @StateObject var connectivity = ConnectivityManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                // 1. Poslouchat příkaz k uložení
                .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RecordFromWatch"))) { notification in
                    saveFromWatch(notification)
                }
                // 2. Při startu odeslat seznam aktivit do hodinek
                .onAppear {
                    syncToWatch()
                }
        }
    }
    
    // Odeslání seznamu názvů do hodinek
    private func syncToWatch() {
        let context = persistenceController.container.viewContext
        let request = Activity.fetchRequest()
        // Seřadíme podle jména
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.name, ascending: true)]
        
        do {
            let activities = try context.fetch(request)
            let names = activities.compactMap { $0.name }
            connectivity.sendActivitiesToWatch(names)
            print("Odeslány aktivity: \(names)")
        } catch {
            print("Chyba CoreData: \(error)")
        }
    }
    
    // Zápis záznamu z hodinek
    private func saveFromWatch(_ notification: Notification) {
        guard let info = notification.userInfo,
              let name = info["activityName"] as? String,
              info["command"] as? String == "record" else { return }
        
        let context = persistenceController.container.viewContext
        let request = Activity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            if let activity = try context.fetch(request).first {
                let newEvent = ActivityEvent(context: context)
                newEvent.id = UUID()
                newEvent.date = Date()
                newEvent.originActivity = activity
                try context.save()
                print("✅ Záznam z hodinek uložen: \(name)")
            }
        } catch {
            print("❌ Chyba ukládání: \(error)")
        }
    }
}
