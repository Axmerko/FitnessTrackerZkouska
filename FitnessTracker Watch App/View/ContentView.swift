//
//  ContentView.swift
//  FitnessTracker Watch App
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var connectivity = ConnectivityManager.shared
    
    var body: some View {
        NavigationStack {
            if connectivity.watchActivities.isEmpty {
                VStack {
                    Image(systemName: "iphone.gen3")
                        .font(.largeTitle)
                        .padding()
                    Text("Otevři aplikaci na iPhone\npro synchronizaci.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } else {
                // Seznam aktivit -> vede na detail
                List(connectivity.watchActivities, id: \.self) { activityName in
                    NavigationLink(destination: WatchDetailView(activityName: activityName)) {
                        Text(activityName)
                            .font(.headline)
                            .padding(.vertical, 8)
                    }
                }
                .navigationTitle("Fitness")
            }
        }
    }
}
