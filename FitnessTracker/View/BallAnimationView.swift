//
//  BallAnimationView.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import SwiftUI

struct BallAnimationView: View {
    let count: Int              // Celkový počet tréninků
    var onFinish: () -> Void    // Co udělat po skončení

    // Zobrazíme maximálně 5 kuliček
    var ballsToShow: Int {
        min(count, 5)
    }

    // Barvy kuliček dle zadání
    let colors: [Color] = [.blue, .red, .green, .orange, .purple, .yellow]

    // Stav pro animaci (počet spadlých kuliček)
    @State private var visibleBallsCount: Int = 0

    var body: some View {
        ZStack {
            // 1. Bílé pozadí (podle zadání)
            Color.white.edgesIgnoringSafeArea(.all)
             
            VStack {
                Spacer()
                 
                // 2. Texty (podle wireframu)
                Text("Great!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                 
                Text("You are building your habits!")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom, 50) // Odsazení od kuliček
                 
                // 3. Kontejner pro kuličky
                ZStack(alignment: .bottom) {
                    // Prázdný rámec, aby kuličky měly kde padat
                    Color.clear.frame(height: 300)
                     
                    // Vykreslení kuliček
                    ForEach(0..<ballsToShow, id: \.self) { index in
                        // Zobrazit kuličku, až když na ni přijde řada
                        if index < visibleBallsCount {
                            Circle()
                                .fill(colors[index % colors.count])
                                .frame(width: 50, height: 50)
                                // Kuličky se skládají na sebe (index 0 je dole)
                                .offset(y: CGFloat(-index * 50))
                                // Animace příletu seshora
                                .transition(.move(edge: .top))
                        }
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimation()
        }
    }

    func startAnimation() {
        // Postupné spouštění kuliček s prodlevou
        for i in 0..<ballsToShow {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                // OPRAVA: Místo .bouncy použijeme .spring, který funguje všude
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 0)) {
                    visibleBallsCount += 1
                }
            }
        }

        // Výpočet času konce: (počet * prodleva) + čas na prohlédnutí
        let totalTime = Double(ballsToShow) * 0.3 + 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + totalTime) {
            onFinish()
        }
    }
}
