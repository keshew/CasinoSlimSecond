import SwiftUI

class AviatorViewModel: ObservableObject {
    let contact = AviatorModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var bet = 50
    @Published var reward: Int = 0
    @Published var isPlaying: Bool = false
    @Published var planeRotation: Double = 0
    @Published var planePositionX: CGFloat = 25
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var planePositionY: CGFloat = -35

    var multiplierString: String {
        if bet == 0 { return "1.00x" }
        let multiplier = Double(reward) / Double(bet)
        return String(format: "%.2fx", max(multiplier, 1.0))
    }
    
    private var fallWorkItem: DispatchWorkItem?
    private var rewardTimer: Timer?
    
    func startGame() {
        guard !isPlaying else { return }
        guard bet <= coin, bet >= 50 else { return }
        UserDefaultsManager.shared.recordBet(bet)
        UserDefaultsManager.shared.startGame()
        soundManager.playWrong()
        isPlaying = true
        reward = 0
        UserDefaultsManager.shared.removeCoins(bet)
        coin = UserDefaultsManager.shared.coins
        UserDefaultsManager.shared.addExperience()
        planeRotation = 0
        planePositionX = 25

        withAnimation(.linear(duration: 3)) {
            self.planePositionX = 150
            self.planePositionY = -50
        }

        startRewardIncrement()

        fallWorkItem?.cancel()

        let fallItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.stopRewardIncrement()

            withAnimation(.linear(duration: 2)) {
                self.planeRotation = 25
                self.planePositionX = 300
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reward = 0
                UserDefaultsManager.shared.recordLoss()
                self.isPlaying = false
                self.resetPlanePosition()
                self.soundManager.stopWrong()
            }
        }
        fallWorkItem = fallItem

        let randomDelay = Double.random(in: 1.0...5.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay, execute: fallItem)

    }

    func collectReward() {
        guard isPlaying else { return }
        self.soundManager.stopWrong()
        stopRewardIncrement()
        UserDefaultsManager.shared.addCoins(reward)
        UserDefaultsManager.shared.recordWin()
        UserDefaultsManager.shared.recordWinAmount(reward)
        coin = UserDefaultsManager.shared.coins
        reward = 0
        isPlaying = false
        resetPlanePosition()
        fallWorkItem?.cancel()
        fallWorkItem = nil
    }

    private func resetPlanePosition() {
        withAnimation(.easeOut(duration: 1)) {
            planeRotation = 0
            planePositionX = 25
            planePositionY = -35
        }
    }

    private func startRewardIncrement() {
        rewardTimer?.invalidate()
        rewardTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, self.isPlaying else { return }
            let increment = Int(Double(self.bet) * 0.1)
            self.reward = min(self.reward + increment, self.bet * 10)
        }
    }

    private func stopRewardIncrement() {
        rewardTimer?.invalidate()
        rewardTimer = nil
    }
}
