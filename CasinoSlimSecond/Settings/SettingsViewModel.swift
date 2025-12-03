import SwiftUI

class SettingsViewModel: ObservableObject {
    let contact = SettingsModel()
    @ObservedObject private var soundManager = SoundManager.shared
    
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var energy = UserDefaultsManager.shared.energy
    @Published var avatarImage: UIImage? = nil
    private let avatarKey = "selectedAvatarImage"
    @Published var playerName: String = UserDefaults.standard.string(forKey: "playerName") ?? "Player Name"
    
    func savePlayerName(_ name: String) {
        playerName = name
        UserDefaults.standard.set(name, forKey: "playerName")
    }
    
    @Published var isSoundOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isOns")
            soundManager.toggleSound()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            soundManager.toggleMusic()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    
    @Published var isNotifOn: Bool {
        didSet {
            soundManager.toggleMusic()
            UserDefaults.standard.set(isNotifOn, forKey: "isNotifOn")
        }
    }
    @Published var isVib: Bool {
        didSet {
            UserDefaults.standard.set(isVib, forKey: "isVib")
        }
    }
    
    init() {
        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        self.isSoundOn = UserDefaults.standard.bool(forKey: "isOns")
        self.isNotifOn = UserDefaults.standard.bool(forKey: "isNotifOn")
        self.isVib = UserDefaults.standard.bool(forKey: "isVib")
        
        NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
            self.coin = UserDefaultsManager.shared.coins
            self.energy = UserDefaultsManager.shared.energy
        }
        
        loadAvatar()
    }
    
    func loadAvatar() {
        if let data = UserDefaults.standard.data(forKey: avatarKey),
           let image = UIImage(data: data) {
            avatarImage = image
        } else {
            avatarImage = nil
        }
    }
    
    func saveAvatar(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: avatarKey)
            avatarImage = image
        }
    }
}

