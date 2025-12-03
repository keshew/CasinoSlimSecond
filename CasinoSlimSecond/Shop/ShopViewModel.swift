import SwiftUI

class ShopViewModel: ObservableObject {
    let contact = ShopModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var energy = UserDefaultsManager.shared.energy

    @Published var timeRemaining: TimeInterval = 0
    @Published var canClaimReward: Bool = false
    
    private let lastClaimKey = "lastDailyRewardClaim"
    private var timer: Timer?
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
            self.coin = UserDefaultsManager.shared.coins
            self.energy = UserDefaultsManager.shared.energy
        }
        checkTimeRemaining()
        startTimer()
    }
    
    func checkTimeRemaining() {
        if let lastClaim = UserDefaults.standard.object(forKey: lastClaimKey) as? Date {
            let now = Date()
            let nextClaimDate = Calendar.current.date(byAdding: .hour, value: 24, to: lastClaim)!
            timeRemaining = max(0, nextClaimDate.timeIntervalSince(now))
            canClaimReward = timeRemaining == 0
        } else {
            canClaimReward = true
            timeRemaining = 0
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.checkTimeRemaining()
        }
    }
    
    func claimReward() {
        guard canClaimReward else { return }
        
        UserDefaultsManager.shared.addCoins(5000)
        
        UserDefaults.standard.set(Date(), forKey: lastClaimKey)
        
        checkTimeRemaining()
    }
    
    func formattedTime() -> String {
        let hours = Int(timeRemaining) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func buyEnergy() {
        guard coin >= 99999 else {
            showAlert = true
            alertMessage = "You don't have enough coins"
            return
        }
        
        UserDefaultsManager.shared.removeCoins(99999)
        UserDefaultsManager.shared.addEnergy(1000)
        
        showAlert = true
        alertMessage = "Successfully!"
    }
    
    deinit {
        timer?.invalidate()
    }
}
