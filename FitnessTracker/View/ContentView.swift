//
//  ContentView.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // Přístup k databázi (získáme ho z prostředí - environment)
    @Environment(\.managedObjectContext) private var viewContext

    // Automatické načítání aktivit seřazených podle data vytvoření
    // Toto se samo postará o aktualizaci seznamu, když něco přidáš
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.createdAt, ascending: true)],
        animation: .default)
    private var activities: FetchedResults<Activity>

    // Stav pro zobrazení modálního okna (Add Exercise)
    @State private var showAddExercise = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // --- 1. VRSTVA: Seznam a nadpis ---
                VStack(alignment: .leading) {
                    Text("Fitness")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    List {
                        ForEach(activities) { activity in
                            // Odkaz na detail (používáme placeholder RecordExerciseView)
                            NavigationLink(destination: RecordExerciseView(activity: activity)) {
                                ActivityRow(activity: activity)
                            }
                        }
                        // Funkce pro mazání přejetím prstu
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain) // Aby seznam neměl šedé pozadí
                }

                // --- 2. VRSTVA: Plovoucí tlačítko ---
                Button(action: {
                    showAddExercise = true
                }) {
                    Text("New exercise")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                }
                .padding(.bottom, 30) // Odsazení od spodního okraje
            }
            // Modální okno, které vyskočí po kliknutí
            .sheet(isPresented: $showAddExercise) {
                AddExerciseView()
            }
        }
    }

    // Pomocná funkce pro smazání řádku z databáze
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { activities[$0] }.forEach(viewContext.delete)
            
            // Uložení změny (smazání)
            do {
                try viewContext.save()
            } catch {
                print("Chyba při mazání: \(error)")
            }
        }
    }
}
