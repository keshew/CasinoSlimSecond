import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var bgPlayer: AVAudioPlayer?
    private var soundBtnPlayer: AVAudioPlayer?
    private var wrongPlayer: AVAudioPlayer?
    private var slot1Player: AVAudioPlayer?

    @Published var backgroundVolume: Float = 1 {
        didSet {
            bgPlayer?.volume = backgroundVolume
        }
    }
    
    @Published var soundEffectVolume: Float = 1 {
        didSet {
            soundBtnPlayer?.volume = soundEffectVolume
            wrongPlayer?.volume = soundEffectVolume
            slot1Player?.volume = soundEffectVolume
        }
    }
    
    @Published var isSoundEnabled: Bool = UserDefaults.standard.bool(forKey: "isOns")
    @Published var isMusicEnabled: Bool = UserDefaults.standard.bool(forKey: "isMusicOn")

    init() {
        loadBackgroundMusic()
        loadSoundBtnMusic()
        loadWrongMusic()
        loadSlot1Music()
        
        if isMusicEnabled {
            playBackgroundMusic()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func appWillResignActive() {
        stopBackgroundMusic()
    }
    
    @objc private func appDidBecomeActive() {
        if isMusicEnabled {
            playBackgroundMusic()
        }
    }
    
    private func loadBackgroundMusic() {
        if let url = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            bgPlayer = try? AVAudioPlayer(contentsOf: url)
            bgPlayer?.numberOfLoops = -1
            bgPlayer?.volume = backgroundVolume
            bgPlayer?.prepareToPlay()
        }
    }
    
    private func loadSoundBtnMusic() {
        if let url = Bundle.main.url(forResource: "soundBtn", withExtension: "mp3") {
            soundBtnPlayer = try? AVAudioPlayer(contentsOf: url)
            soundBtnPlayer?.volume = soundEffectVolume
            soundBtnPlayer?.prepareToPlay()
        }
    }
    
    private func loadWrongMusic() {
        if let url = Bundle.main.url(forResource: "aviator", withExtension: "wav") {
            wrongPlayer = try? AVAudioPlayer(contentsOf: url)
            wrongPlayer?.volume = soundEffectVolume
            wrongPlayer?.prepareToPlay()
        }
    }
    
    private func loadSlot1Music() {
        if let url = Bundle.main.url(forResource: "slot1", withExtension: "mp3") {
            slot1Player = try? AVAudioPlayer(contentsOf: url)
            slot1Player?.volume = soundEffectVolume
            slot1Player?.prepareToPlay()
        }
    }
    
    func playBackgroundMusic() {
        guard isMusicEnabled else { return }
        bgPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        bgPlayer?.stop()
    }
    
    func stopSlot() {
        slot1Player?.stop()
    }
    
    func stopWrong() {
        wrongPlayer?.stop()
    }
    
    
    func playSoundBtn() {
        guard isSoundEnabled else { return }
        soundBtnPlayer?.play()
    }
    
    func playWrong() {
        guard isSoundEnabled else { return }
        wrongPlayer?.play()
    }
    
    func playSlot1() {
        guard isSoundEnabled else { return }
        slot1Player?.play()
    }
    
    func toggleSound() {
        isSoundEnabled.toggle()
        UserDefaults.standard.set(isSoundEnabled, forKey: "isOns")
    }
    
    func toggleMusic() {
        isMusicEnabled.toggle()
        if isMusicEnabled {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
        UserDefaults.standard.set(isMusicEnabled, forKey: "isMusicOn")
    }
}
