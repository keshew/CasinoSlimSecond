import SwiftUI

class GamesViewModel: ObservableObject {
    let contact = GamesModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var energy = UserDefaultsManager.shared.energy
    
    init() {
        NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
            self.coin = UserDefaultsManager.shared.coins
            self.energy = UserDefaultsManager.shared.energy
        }
    }
}
