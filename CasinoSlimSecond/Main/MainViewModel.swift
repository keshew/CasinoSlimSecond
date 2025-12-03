import SwiftUI

class MainViewModel: ObservableObject {
    let contact = MainModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var energy = UserDefaultsManager.shared.energy
    @Published var xp = UserDefaultsManager.shared.totalExperience
    @Published var playerName: String = UserDefaults.standard.string(forKey: "playerName") ?? "Player Name"
    @Published var avatarImage: UIImage? = nil
    private let avatarKey = "selectedAvatarImage"
    @Published var achievements: [Achievments] = []
    
    init() {
        loadAvatar()
        NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
            self.loadAvatar()
            self.playerName = UserDefaults.standard.string(forKey: "playerName") ?? "Player Name"
            self.coin = UserDefaultsManager.shared.coins
            self.energy = UserDefaultsManager.shared.energy
            self.xp = UserDefaultsManager.shared.totalExperience
        }
        loadData()
    }
    
    func loadAvatar() {
        if let data = UserDefaults.standard.data(forKey: avatarKey),
           let image = UIImage(data: data) {
            avatarImage = image
        } else {
            avatarImage = nil
        }
    }
    
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
}
