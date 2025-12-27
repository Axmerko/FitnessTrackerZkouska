//
//  ActivityRow.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

struct ActivityRow: View {
    // Řádek potřebuje vědět, co má zobrazit -> dostane Activitu
    // @ObservedObject sleduje změny (kdyby se změnilo jméno nebo přibyl záznam, překreslí se)
    @ObservedObject var activity: Activity

    var body: some View {
        HStack {
            // Vlevo: Název sportu
            Text(activity.name ?? "Unknown")
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            // Vpravo: Sloupeček s číslem a popiskem
            VStack(alignment: .trailing) {
                // Použijeme náš vypočítaný průměr z Modelu
                // %.1f znamená jedno desetinné místo (např. 0.5 nebo 2.0)
                Text(String(format: "%.1f", activity.eventsPerDay))
                    .font(.body)
                
                Text("per day")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8) // Trochu vzduchu nahoru a dolů
    }
}
