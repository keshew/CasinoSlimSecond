import SwiftUI

@main
struct CasinoSlimSecondApp: App {
    
    init() {
        let stats = UserDefaultsManager.shared
        let key = "didAddInitialCoins"
        if !UserDefaults.standard.bool(forKey: key) {
            stats.addCoins(5000)
            stats.addEnergy(100)
            UserDefaults.standard.set(true, forKey: "isMusicOn")
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Loading()
        }
    }
}
