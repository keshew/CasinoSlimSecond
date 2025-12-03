import SwiftUI

class AchievViewModel: ObservableObject {
    let contact = AchievModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var energy = UserDefaultsManager.shared.energy
    @Published var achievements: [Achievments] = []
    
    var completedAchievs: [Achievments] {
        achievements.filter { $0.isDone }
    }
    
    var uncompletedAchievs: [Achievments] {
        achievements.filter { !$0.isDone }
    }
    
    func loadData() {
        let manager = UserDefaultsManager.shared
        achievements = manager.achievements
        energy = manager.energy
        coin = manager.coins
    }
    
    func refresh() {
        loadData()
    }
    
    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
            self.coin = UserDefaultsManager.shared.coins
            self.energy = UserDefaultsManager.shared.energy
        }
        loadData()
    }
}
