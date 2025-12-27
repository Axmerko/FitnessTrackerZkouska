//
//  Activity+Logic.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import Foundation
import CoreData

extension Activity {

    // 1. Pomocná vlastnost: Převedeme NSSet (neuspořádaný balík) na seřazené pole
    // To potřebujeme, abychom věděli, který záznam byl první a který poslední.
    public var eventsArray: [ActivityEvent] {
        let set = events as? Set<ActivityEvent> ?? []
        return set.sorted {
            ($0.date ?? Date()) < ($1.date ?? Date())
        }
    }
    
    // 2. Datum prvního záznamu (pro detail obrazovku)
    public var firstRecordDate: Date? {
        return eventsArray.first?.date
    }
    
    // 3. Datum posledního záznamu (pro detail obrazovku)
    public var lastRecordDate: Date? {
        return eventsArray.last?.date
    }
    
    // 4. Počet záznamů (pro seznam i detail)
    public var numberOfEvents: Int {
        eventsArray.count
    }
    
    // 5. Výpočet průměru dle zadání: (Počet / Dny mezi prvním a posledním)
    public var eventsPerDay: Double {
        // Pokud máme 0 nebo 1 záznam, průměr je prostě počet (nebo 0)
        guard let first = eventsArray.first?.date,
              let last = eventsArray.last?.date,
              numberOfEvents > 1 else {
            return Double(numberOfEvents)
        }
        
        let calendar = Calendar.current
        // Spočítáme rozdíl ve dnech
        let components = calendar.dateComponents([.day], from: first, to: last)
        
        // Ošetření dělení nulou (kdyby to bylo ve stejný den, dáme 1)
        let daysDiff = max(1, components.day ?? 1)
        
        return Double(numberOfEvents) / Double(daysDiff)
    }
}
