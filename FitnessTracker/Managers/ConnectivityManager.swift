//
//  ConnectivityManager.swift
//  FitnessTracker
//
//  Created by Miroslav Adrian Axmann on 27.12.2025.
//

import Foundation
import WatchConnectivity

final class ConnectivityManager: NSObject, ObservableObject {
    
    static let shared = ConnectivityManager()
    
    // Data pro hodinky (seznam aktivit)
    @Published var watchActivities: [String] = []

    override private init() {
        super.init()
        // Automaticky aktivovat session při startu
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // ------------------------------------------
    // METODY PRO IPHONE (Odesílání seznamu)
    // ------------------------------------------
    
    func sendActivitiesToWatch(_ activities: [String]) {
        guard WCSession.default.activationState == .activated else { return }
        
        // Použijeme ApplicationContext - je to nejspolehlivější pro udržení stavu dat
        do {
            try WCSession.default.updateApplicationContext(["activities": activities])
        } catch {
            print("Chyba při odesílání do hodinek: \(error)")
        }
    }
    
    // ------------------------------------------
    // METODY PRO HODINKY (Odeslání záznamu)
    // ------------------------------------------
    
    func sendRecordToPhone(activityName: String) {
        guard WCSession.default.isReachable else {
            print("iPhone není dosažitelný (aplikace musí běžet nebo být na pozadí)")
            return
        }
        
        let message = ["command": "record", "activityName": activityName]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Chyba při odesílání záznamu: \(error.localizedDescription)")
        }
    }
}

// ------------------------------------------
// DELEGATE (Příjem zpráv)
// ------------------------------------------

extension ConnectivityManager: WCSessionDelegate {
    
    // 1. Aktivace dokončena (Obě platformy)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WCSession aktivována: \(activationState.rawValue)")
    }
    
    // 2. Příjem kontextu (Hodinky přijímají seznam aktivit z mobilu)
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let activities = applicationContext["activities"] as? [String] {
            DispatchQueue.main.async {
                self.watchActivities = activities
            }
        }
    }
    
    // 3. Příjem zprávy (iPhone přijímá příkaz k záznamu)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name("RecordFromWatch"), object: nil, userInfo: message)
        }
    }
    
    // 4. iOS specifické metody (Nutné aby to nepadalo na iPhone)
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        // Pokud se session zruší (např. spárování jiných hodinek), znovu ji aktivujeme
        WCSession.default.activate()
    }
    #endif
}
