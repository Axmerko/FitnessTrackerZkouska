//
//  AddExerciseView.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

struct AddExerciseView: View {
    // Potřebujeme přístup k databázi, abychom mohli uložit nový sport
    @Environment(\.managedObjectContext) private var viewContext
    
    // Potřebujeme funkci "dismiss", abychom okno zavřeli (Cancel/Save)
    @Environment(\.dismiss) private var dismiss

    // Stavová proměnná pro textové pole
    @State private var name: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // Nadpis pod horní lištou
                Text("Add Exercise")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Popisek pole
                Text("Description")
                    .font(.headline)
                
                // Pole pro psaní
                TextField("Swimming", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
            }
            .padding()
            // Horní lišta s tlačítky
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExercise()
                    }
                    // Pojistka: nepovolit uložení, když je název prázdný
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func saveExercise() {
        withAnimation {
            // 1. Vytvoříme novou instanci Activity v kontextu databáze
            let newActivity = Activity(context: viewContext)
            
            // 2. Naplníme daty
            let newId = UUID()
            newActivity.id = newId
            newActivity.name = name
            newActivity.createdAt = Date() // Důležité pro řazení
            
            // 3. Uložíme do databáze
            do {
                try viewContext.save()
                
                // TODO: Zde později přidáme odeslání na hodinky (ConnectivityManager)
                
                // 4. Zavřeme okno
                dismiss()
            } catch {
                print("Chyba při ukládání: \(error)")
            }
        }
    }
}
