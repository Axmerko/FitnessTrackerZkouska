//
//  Activity+Logic.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import Foundation
import CoreData

extension Activity {

    // 1. Pomocná vlastnost: Převedeme NSSet na seřazené pole
    public var eventsArray: [ActivityEvent] {
        let set = events as? Set<ActivityEvent> ?? []
        return set.sorted {
            ($0.date ?? Date()) < ($1.date ?? Date())
        }
    }
    
    // 2. Datum prvního záznamu
    public var firstRecordDate: Date? {
        return eventsArray.first?.date
    }
    
    // 3. Datum posledního záznamu
    public var lastRecordDate: Date? {
        return eventsArray.last?.date
    }
    
    // 4. Počet záznamů
    public var numberOfEvents: Int {
        eventsArray.count
    }
    
    // 5. Výpočet průměru (Skóre)
    // Aby vyšlo 0.5, musí to být Double a dělit se počtem dní OD ZAČÁTKU DO TEĎ
    public var eventsPerDay: Double {
        guard let first = eventsArray.first?.date else {
            return 0.0
        }
        
        let calendar = Calendar.current
        
        // Zarovnáme data na začátek dne (půlnoc)
        let startOfFirst = calendar.startOfDay(for: first)
        let startOfNow = calendar.startOfDay(for: Date()) // ZMĚNA: Porovnáváme s dneškem
        
        // Spočítáme rozdíl ve dnech mezi prvním tréninkem a dneškem
        let components = calendar.dateComponents([.day], from: startOfFirst, to: startOfNow)
        
        // Pokud jsem začal dnes, je to 1 den (abychom nedělili nulou)
        // Pokud jsem začal před 2 dny, bude to 2, atd.
        let daysDiff = max(1, (components.day ?? 0) + 1)
        
        // Příklad: 1 trénink za 2 dny -> 1.0 / 2.0 = 0.5
        return Double(numberOfEvents) / Double(daysDiff)
    }
}
