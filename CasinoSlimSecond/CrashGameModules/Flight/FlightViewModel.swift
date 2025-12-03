import SwiftUI
import Combine

class FlightViewModel: ObservableObject {
    let contact = FlightModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var bet = 50
    @Published var reward: Int = 0
    @Published var isPlaying: Bool = false
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default.publisher(for: .rewardUpdatedNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if let reward = notification.userInfo?["reward"] as? Int {
                    self?.reward = reward
                    self?.coin = UserDefaultsManager.shared.coins
                    print("ViewModel reward updated: \(reward)")
                }
            }
    }
    
    var multiplierString: String {
          if bet == 0 { return "X1.00" }
          let multiplier = Double(reward) / Double(bet)
          return String(format: "X%.2f", max(multiplier, 1.0))
      }

      func startGame() {
          guard !isPlaying && bet >= 50 && bet <= coin else { return }
          UserDefaultsManager.shared.addExperience()
          UserDefaultsManager.shared.removeCoins(bet)
          UserDefaultsManager.shared.recordBet(bet)
          UserDefaultsManager.shared.startGame()
          coin = UserDefaultsManager.shared.coins
          reward = 0
          isPlaying = true
          print("PLAYING")
      }

      func collectReward() {
          guard isPlaying else { return }
          UserDefaultsManager.shared.addCoins(reward)
          UserDefaultsManager.shared.recordWin()
          UserDefaultsManager.shared.recordWinAmount(reward)
          coin = UserDefaultsManager.shared.coins
          reward = 0
          isPlaying = false
      }
      
      func resetAndStartGame() {
          reward = 0
          startGame()
      }
  }
