//
//  RecordExerciseView.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

struct RecordExerciseView: View {
    // Konkrétní aktivita, kterou zobrazujeme
    @ObservedObject var activity: Activity
    
    // Přístup k databázi (pro uložení nového záznamu)
    @Environment(\.managedObjectContext) private var viewContext
    
    // Pro zavření okna (návrat zpět)
    @Environment(\.dismiss) private var dismiss
    
    // Stav pro DatePicker
    @State private var date = Date()
    
    // Stav pro zobrazení animace
    @State private var showAnimation = false

    var body: some View {
        ZStack {
            // --- HLAVNÍ OBSAH ---
            VStack(alignment: .leading, spacing: 20) {
                 
                // Velký nadpis dle zadání
                Text("Record Exercise")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                 
                Group {
                    // Statistiky (čerpají data z Activity+Logic)
                    infoRow(label: "First record:", value: formatDate(activity.firstRecordDate))
                    infoRow(label: "Last record:", value: formatDate(activity.lastRecordDate))
                    infoRow(label: "Number of events:", value: "\(activity.numberOfEvents)")
                    
                    // --- NOVÝ ŘÁDEK PRO ZOBRAZENÍ PRŮMĚRU (0.5 atd.) ---
                    infoRow(label: "Daily Score:", value: String(format: "%.1f", activity.eventsPerDay))
                }
                 
                Divider()
                 
                // Výběr data
                Text("Date")
                    .font(.headline)
                 
                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                 
                Spacer()
                 
                // Tlačítko RECORD
                Button(action: {
                    recordNewEvent()
                }) {
                    Text("Record")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal)
            
            // --- PŘEKRYTÍ ANIMACÍ ---
            if showAnimation {
                BallAnimationView(count: activity.numberOfEvents, onFinish: {
                    // Až animace skončí:
                    showAnimation = false
                    dismiss() // Zavřeme detail a vrátíme se na seznam
                })
                .zIndex(1) // Zajistí, že animace bude nad vším ostatním
            }
        }
        // Nastavení názvu v horní liště
        .navigationTitle(activity.name ?? "Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // --- Logika uložení ---
    private func recordNewEvent() {
        withAnimation {
            // 1. Vytvoříme nový záznam (ActivityEvent)
            let newEvent = ActivityEvent(context: viewContext)
            newEvent.id = UUID()
            newEvent.date = date
            
            // 2. Propojíme ho s aktivitou (Relationship)
            newEvent.originActivity = activity
            
            // 3. Uložíme do Core Data
            do {
                try viewContext.save()
                // 4. Spustíme animaci
                showAnimation = true
            } catch {
                print("Chyba při ukládání záznamu: \(error)")
            }
        }
    }
    
    // --- Pomocné funkce pro vzhled ---
    func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
    
    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "-" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
