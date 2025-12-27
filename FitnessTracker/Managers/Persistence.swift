//
//  Persistence.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import CoreData

struct PersistenceController {
    // Singleton - jedna instance pro celou aplikaci
    static let shared = PersistenceController()

    // Kontejner pro databázi
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Zde musí být přesný název tvého .xcdatamodeld souboru
        container = NSPersistentContainer(name: "FitnessTracker")
        
        if inMemory {
            // Pro preview a testy (neukládá na disk)
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        // Automaticky slučovat změny (důležité pro synchronizaci a aktualizace UI)
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Pomocná funkce pro uložení
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
