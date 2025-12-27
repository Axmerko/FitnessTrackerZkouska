//
//  WatchDetailView.swift
//  FitnessTracker Watch App
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

struct WatchDetailView: View {
    let activityName: String
    @State private var isRecorded = false // Pro vizuální potvrzení
    
    var body: some View {
        VStack {
            Spacer()
            
            // Název aktivity
            Text(activityName)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            // Velké tlačítko RECORD
            Button(action: {
                // 1. Odeslat signál do telefonu
                ConnectivityManager.shared.sendRecordToPhone(activityName: activityName)
                
                // 2. Vizuální efekt (zezelenání)
                withAnimation {
                    isRecorded = true
                }
                
                // 3. Reset tlačítka po chvilce
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        isRecorded = false
                    }
                }
            }) {
                VStack {
                    if isRecorded {
                        Image(systemName: "checkmark")
                            .font(.largeTitle)
                    } else {
                        Text("Record")
                            .font(.headline)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60) // Výška tlačítka
            }
            .background(isRecorded ? Color.green : Color.blue)
            .cornerRadius(30) // Kulaté rohy
            .padding(.horizontal)
            
            Spacer()
        }
    }
}
